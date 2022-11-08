extends Area2D

signal missile_destroyed
signal enemy_hit
signal obstacle_hit

export (int) var speed = 200
export (PackedScene) var explosion

var velocity = Vector2(0, 0)
var angle = 0
var is_following_mouse = false
var recalculate_angle = false
var previous_cursor_position = Vector2.ZERO

func _ready():
	velocity = Vector2.RIGHT


func _process(delta):
	var cursor_position = get_global_mouse_position()
	if previous_cursor_position == cursor_position:
		recalculate_angle = false
	else:
		previous_cursor_position = cursor_position
		recalculate_angle = true

	if recalculate_angle:
		if not is_following_mouse:
			angle = rotation
		else:
			angle = (cursor_position - global_position).angle()

		look_at(cursor_position)
		velocity = Vector2.RIGHT.rotated(angle) * speed * delta
		translate(velocity)
	else:
		translate(velocity)


func _on_FollowCursorTimer_timeout():
	is_following_mouse = true


func _on_DestroyTimer_timeout():
	print_debug("Missile time ran out")
	emit_signal("missile_destroyed")
	queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	print_debug("Missile out of bounds")
	emit_signal("missile_destroyed")
	queue_free()


func _on_PlayerMissile_area_entered(area):
	var node_name = str(area.name.replace("@", "").replace(str(int(area.name)), ""))
	if node_name == "Enemy":
		emit_signal("enemy_hit", area)
	elif node_name == "Obstacle":
		var spawned_explosion = explosion.instance()
		get_tree().get_root().add_child(spawned_explosion)
		spawned_explosion.position = get_position()
		emit_signal("obstacle_hit", area)
		emit_signal("missile_destroyed")
		queue_free()

extends Area2D

signal missile_destroyed
signal enemy_hit
signal obstacle_hit
signal powerup_hit

export (int) var speed = 200
export (PackedScene) var explosion
export (float) var recalculate_threshold = 10.0

var velocity := Vector2(0, 0)
var angle: float = 0
var is_following_cursor: bool = false
var recalculate_angle: bool = false
var previous_cursor_position := Vector2.ZERO
var shot_progress_bar = null

func _ready():
	velocity = Vector2.RIGHT


func _process(delta: float):
	var cursor_position = get_global_mouse_position()
	if abs(previous_cursor_position.distance_to(cursor_position)) >= recalculate_threshold:
		previous_cursor_position = cursor_position
		recalculate_angle = true
	else:
		recalculate_angle = false

	if recalculate_angle:
		if not is_following_cursor:
			angle = rotation
		else:
			angle = (cursor_position - global_position).angle()

		look_at(cursor_position)
		velocity = Vector2.RIGHT.rotated(angle) * speed * delta
		translate(velocity)
	else:
		translate(velocity)

	if is_instance_valid(shot_progress_bar):
		shot_progress_bar.value = $DestroyTimer.time_left / $DestroyTimer.wait_time * 100


func _on_FollowCursorTimer_timeout():
	is_following_cursor = true

func set_shot_progress_bar(bar):
	shot_progress_bar = bar

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
		if is_instance_valid($DestroyTimer):
			$DestroyTimer.start($DestroyTimer.time_left + 1)
		emit_signal("enemy_hit", area, self)
	elif node_name == "Obstacle":
		var spawned_explosion = explosion.instance()
		get_tree().get_root().add_child(spawned_explosion)
		spawned_explosion.position = get_position()
		spawned_explosion.emitting = true
		emit_signal("obstacle_hit", area)
		emit_signal("missile_destroyed")
		queue_free()
	elif node_name == "PowerUp":
		emit_signal("powerup_hit", area, self)

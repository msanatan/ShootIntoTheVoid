extends Area2D

signal enemy_missile_destroyed

export(int) var speed = 200
export(int) var damage = 10
export(PackedScene) var explosion

var velocity = Vector2(0, 0)
var angle = 0
var player_position = Vector2(0, 0)


func _ready():
	velocity = Vector2.RIGHT


func _process(delta):
	angle = (player_position - global_position).angle()
	velocity = Vector2.RIGHT.rotated(angle) * speed * delta
	translate(velocity)


func _on_EnemyMissile_body_entered(body):
	var spawned_explosion = explosion.instance()
	get_tree().get_root().add_child(spawned_explosion)
	spawned_explosion.position = get_position()
	spawned_explosion.emitting = true
	emit_signal("enemy_missile_destroyed", body, damage)
	queue_free()


func _on_EnemyMissile_area_entered(area):
	var node_name = str(area.name.replace("@", "").replace(str(int(area.name)), ""))
	if node_name == "Obstacle":
		var spawned_explosion = explosion.instance()
		get_tree().get_root().add_child(spawned_explosion)
		spawned_explosion.position = get_position()
		spawned_explosion.emitting = true
		emit_signal("enemy_missile_destroyed", area, 0)
		queue_free()

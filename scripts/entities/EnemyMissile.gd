extends Area2D

signal enemy_missile_destroyed

export (int) var speed = 200
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
	emit_signal("enemy_missile_destroyed")
	queue_free()

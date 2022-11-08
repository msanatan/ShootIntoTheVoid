extends KinematicBody2D

var is_shooting = false
export (PackedScene) var missile

export var health = 100
var score = 0

signal health_decreased
signal player_died
signal score_increased

func _input(event):
	if event.is_action_pressed("attack") and not is_shooting:
		is_shooting = true
		print_debug("Firing missile")
		var spawned_missile = missile.instance()
		get_tree().get_root().add_child(spawned_missile)
		spawned_missile.position = $BulletSpawnPoint.global_position
		spawned_missile.look_at(get_global_mouse_position())
		spawned_missile.connect("missile_destroyed", self, "_on_PlayerMissile_missile_destroyed")
		spawned_missile.connect("enemy_hit", self, "_on_PlayerMissile_enemy_hit")


func _physics_process(delta):
	if not is_shooting:
		look_at(get_global_mouse_position())


func _on_PlayerMissile_missile_destroyed():
	is_shooting = false
	
func _on_PlayerMissile_enemy_hit(enemy):
	increaseScore(100)
	
func increaseScore(amount):
	score += amount
	emit_signal("score_increased", score)
	
func decreaseHealth(amount):
	health -= amount
	emit_signal("health_decreased", health)
	
	if health < 0:
		health = 0
		emit_signal("player_died")

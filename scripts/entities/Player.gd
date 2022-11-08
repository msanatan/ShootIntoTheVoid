extends KinematicBody2D

signal fire_missile
export (PackedScene) var missile

var is_shooting = false

func _input(event):
	if event.is_action_pressed("attack") and not is_shooting:
		print_debug("Firing missile")
		is_shooting = true
		emit_signal("fire_missile")
		var spawned_missile = missile.instance()
		get_tree().get_root().add_child(spawned_missile)
		spawned_missile.position = $BulletSpawnPoint.global_position
		spawned_missile.look_at(get_global_mouse_position())
		spawned_missile.connect("missile_destroyed", self, "_on_PlayerMissile_missile_destroyed")


func _physics_process(delta):
	if not is_shooting:
		look_at(get_global_mouse_position())


func _on_PlayerMissile_missile_destroyed():
	is_shooting = false

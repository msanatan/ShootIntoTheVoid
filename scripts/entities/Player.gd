extends KinematicBody2D

signal fire_missile
var is_shooting = false

func _input(event):
    if event.is_action_pressed("attack") and not is_shooting:
        is_shooting = true
        emit_signal("fire_missile", get_position(), get_global_mouse_position())


func _physics_process(delta):
    if not is_shooting:
        look_at(get_global_mouse_position())

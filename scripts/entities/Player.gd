extends KinematicBody2D

var is_shooting = false


func _physics_process(delta):
    if not is_shooting:
        look_at(get_global_mouse_position())

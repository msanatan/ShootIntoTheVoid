extends Area2D

export (int) var speed = 200
var velocity = Vector2(0, 0)
var angle = 0
var is_following_mouse = false

func _ready():
    velocity = Vector2.RIGHT


func _process(delta):
    var mouse_position = get_global_mouse_position()
    if not is_following_mouse:
        angle = rotation
    else:
        angle = (mouse_position - global_position).angle()

    look_at(mouse_position)
    velocity = Vector2.RIGHT.rotated(angle) * speed * delta
    translate(velocity)


func _on_FollowCursorTimer_timeout():
    is_following_mouse = true


func _on_DestroyTimer_timeout():
    queue_free()

extends Area2D

export (int) var speed = 200
var velocity = Vector2(0, 0)

func _ready():
    print_debug("Missile launched")
    velocity = Vector2.RIGHT

func _process(delta):
    velocity = Vector2.RIGHT.rotated(rotation) * speed * delta
    translate(velocity)


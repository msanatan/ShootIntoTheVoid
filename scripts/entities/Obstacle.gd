extends Area2D

export (PackedScene) var orbit_circle

var count = 0
var radius = 200
var speed = 0.6
var is_moving = false
var screen_center = null
var rand = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	rand.randomize()	
	screen_center = get_viewport_rect().size / 2
	init_motion()

func init_motion():
	radius = position.distance_to(screen_center)
	speed = rand.randf_range(0.1, 0.6)
	
	var circle = orbit_circle.instance()
	circle.size.x = radius*2
	circle.size.y = radius*2
	circle.position = screen_center
	get_tree().get_root().get_node("Main/Orbits").add_child(circle)
		
	is_moving = true	

func _process(delta):
	if is_moving:
		count += delta	
		position = Vector2(sin(count * speed) * radius, cos(count * speed) * radius) + screen_center
		rotation = count * radius/2000

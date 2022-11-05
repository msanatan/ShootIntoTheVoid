extends Position2D

onready var screen_size = get_viewport().get_visible_rect().size
var spawn_locs = Array()
var min_dist = 50
var rand = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	rand.randomize()
	
func spawn(amount):
	var enemy_scene = load("res://scenes/entities/enemies/TestEnemy.tscn")
	
	for i in range(0, amount):
		var enemy = enemy_scene.instance()
		var next_loc = getNextSpawnLoc(enemy)
		if next_loc.x != -1 && next_loc.y != -1:
			enemy.position = next_loc
			add_child(enemy)
		else:
			enemy.queue_free()
			
func isOverlapping(x1, y1, w1, h1, x2, y2, w2, h2):
	var r1 = Rect2(x1 - w1/2,y1 - h1/2,w1,h1)
	var r2 = Rect2(x2 - w2/2,y2 - h2/2,w2,h2)
	return r1.intersects(r2)
		
func getNextSpawnLoc(enemy):
	var sprite_node = enemy.get_node("Area2D/Sprite")
	var w = sprite_node.texture.get_width() * sprite_node.transform.get_scale().x
	var h = sprite_node.texture.get_height() * sprite_node.transform.get_scale().y
	var max_attempts = 10
	var attempt_count = 0
	while attempt_count < max_attempts:
		var x = rand.randf_range(w, screen_size.x - w)
		var y = rand.randf_range(h, screen_size.y - h)
		var new_loc = Vector2(x,y)
		var too_close = false
		for loc in spawn_locs:
			var overlap = isOverlapping(x, y, w, h, loc.location.x, loc.location.y, loc.width, loc.height)
			if overlap:
				too_close = true
				break
		if !too_close:
			spawn_locs.append({
				location = new_loc,
				width = w,
				height = h
			})
			return new_loc
		else:
			attempt_count += 1
	return Vector2(-1, -1)

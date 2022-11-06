extends Position2D

onready var screen_size = get_viewport().get_visible_rect().size
var spawn_locs = Array()
var min_dist = 20
var rand = RandomNumberGenerator.new()

export(NodePath) var player
var player_scene = null;

export(PackedScene) var enemy_missile

# Called when the node enters the scene tree for the first time.
func _ready():
	rand.randomize()
	player_scene = get_node(player)
	if player_scene != null:
		var player_node = player_scene.get_node("Sprite")
		spawn_locs.append({
			location = player_scene.transform.get_origin(),
			width = player_node.texture.get_width() * player_scene.transform.get_scale().x,
			height = player_node.texture.get_height() * player_scene.transform.get_scale().y
		})
	else:
		printerr("Player is not assigned!")
		get_tree().quit()
		
func createInstance(enemy_scene, rotate_to_player):
	var enemy = enemy_scene.instance()
	var next_loc = getNextSpawnLoc(enemy)
	if next_loc.x != -1 && next_loc.y != -1:
		enemy.position = next_loc
		if rotate_to_player:
			enemy.rotation = (player_scene.global_position - enemy.global_position).angle() + PI/2
		add_child(enemy)
		return enemy
	else:
		enemy.queue_free()
	
func spawn(amount, enemy_path, rotate_to_player):
	var enemy_scene = load(enemy_path)
	
	for _i in range(0, amount):
		var enemy = createInstance(enemy_scene, rotate_to_player)
			
func spawnRandomFromList(amount, list, rotate_to_player):
	if list.size() > 0:
		for _i in range(0, amount):
			var random_enemy = list[rand.randi_range(0, list.size()-1)];
			var enemy = createInstance(random_enemy, rotate_to_player)
			
func isOverlapping(x1, y1, w1, h1, x2, y2, w2, h2):
	var r1 = Rect2(x1 - w1/2,y1 - h1/2,w1,h1)
	var r2 = Rect2(x2 - w2/2,y2 - h2/2,w2,h2)
	return r1.intersects(r2)
		
func getNextSpawnLoc(enemy):
	var sprite_node = enemy.get_node("Sprite")
	var w = sprite_node.texture.get_width() * enemy.transform.get_scale().x
	var h = sprite_node.texture.get_height() * enemy.transform.get_scale().y
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

extends Position2D

export (NodePath) var player
var spawn_locs = Array()
var min_dist = 20
var rand = RandomNumberGenerator.new()
var player_scene = null
onready var screen_size = get_viewport().get_visible_rect().size

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

func create_instance(entity_scene, rotate_to_player):
	var entity = entity_scene.instance()
	
	var node_name = str(entity.name.replace("@", "").replace(str(int(entity.name)), ""))
	if node_name == "Enemy":
		entity.set_player(player_scene)
	elif node_name == "Obstacle":
		entity.rotation = rand.randf_range(0, PI)
	
	var next_loc = get_next_spawn_loc(entity)
	if next_loc.x != -1 && next_loc.y != -1:
		entity.position = next_loc
		if rotate_to_player:
			entity.rotation = (player_scene.global_position - entity.global_position).angle() + PI/2
		add_child(entity)
		return entity

	entity.queue_free()


func spawn(amount, entity_path, rotate_to_player):
	var entity_scene = load(entity_path)

	for _i in range(0, amount):
		var entity = create_instance(entity_scene, rotate_to_player)

func spawn_random_from_list(amount, list, rotate_to_player):
	if list.size() > 0:
		for _i in range(0, amount):
			var random_entity = list[rand.randi_range(0, list.size()-1)];
			var entity = create_instance(random_entity, rotate_to_player)
			
func spawn_random_from_list_with_chance(amount, list, rotate_to_player, limit, chance):
	if list.size() > 0:
		for _i in range(0, amount):
			var value = rand.randi_range(0, limit)
			var should_spawn = value <= chance
			if should_spawn:
				var random_entity = list[rand.randi_range(0, list.size()-1)];
				var entity = create_instance(random_entity, rotate_to_player)

func is_overlapping(x1, y1, w1, h1, x2, y2, w2, h2):
	var r1 = Rect2(x1 - w1/2,y1 - h1/2,w1,h1)
	var r2 = Rect2(x2 - w2/2,y2 - h2/2,w2,h2)
	return r1.intersects(r2)

func get_next_spawn_loc(entity):
	var sprite_node = entity.get_node("Sprite")
	var w = sprite_node.texture.get_width() * entity.transform.get_scale().x
	var h = sprite_node.texture.get_height() * entity.transform.get_scale().y
	var max_attempts = 10
	var attempt_count = 0
	while attempt_count < max_attempts:
		var x = rand.randf_range(w, screen_size.x - w)
		var y = rand.randf_range(h, screen_size.y - h)
		var new_loc = Vector2(x,y)
		var too_close = false
		for loc in spawn_locs:
			var overlap = is_overlapping(x, y, w, h, loc.location.x, loc.location.y, loc.width, loc.height)
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

		attempt_count += 1
	return Vector2(-1, -1)

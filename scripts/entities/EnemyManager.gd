extends Node

export(NodePath) var spawner
export(Array, PackedScene) var easy_enemy_list
export(Array, PackedScene) var medium_enemy_list
export(Array, PackedScene) var hard_enemy_list
export(Array, PackedScene) var easy_shielded_enemy_list
export(Array, PackedScene) var medium_shielded_enemy_list
export(Array, PackedScene) var hard_shielded_enemy_list
export(Array, PackedScene) var boss_shielded_enemy_list
export(Array, PackedScene) var small_obstacle_list
export(Array, PackedScene) var medium_obstacle_list
export(Array, PackedScene) var large_obstacle_list
export(Array, PackedScene) var powerup_list
var spawner_node = null
var num_enemies = 0
var num_shots_fired = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	spawner_node = get_node(spawner)
	if spawner_node == null:
		printerr("Spawner is not assigned!")
		get_tree().quit()

func handle_boss_sequence(level):
	if level % 5 == 0:
		var next_order = 0
		var boss_anim_node = get_tree().get_root().get_node("Main/UI/BossAnimationPlayer")
		
		if level == 5:
			next_order = spawner_node.spawn_random_shielded_from_list(3, easy_shielded_enemy_list, true, 1)
			next_order = spawner_node.spawn_random_shielded_from_list(1, boss_shielded_enemy_list, true, next_order, 1000)
						
			spawner_node.spawn_random_from_list(2, small_obstacle_list, false)
			spawner_node.spawn_random_from_list(2, medium_obstacle_list, false)
			spawner_node.spawn_random_from_list(2, large_obstacle_list, false)
			spawner_node.spawn_random_from_list_with_chance(1, powerup_list, false, 10, 4)
			
			if Globals.show_tutorial:
				spawner_node.player_scene.can_shoot = false
				var tutorial2_dialog = Dialogic.start("Tutorial2")
				tutorial2_dialog.connect("timeline_end", self, "tutorial_ended")
				add_child(tutorial2_dialog)
		elif level == 10:
			next_order = spawner_node.spawn_random_shielded_from_list(3, easy_shielded_enemy_list, true, 1)
			next_order = spawner_node.spawn_random_shielded_from_list(2, medium_shielded_enemy_list, true, next_order)
			next_order = spawner_node.spawn_random_shielded_from_list(1, boss_shielded_enemy_list, true, next_order, 1000)
						
			spawner_node.spawn_random_from_list(3, small_obstacle_list, false)
			spawner_node.spawn_random_from_list(3, medium_obstacle_list, false)
			spawner_node.spawn_random_from_list(2, large_obstacle_list, false)
			spawner_node.spawn_random_from_list_with_chance(1, powerup_list, false, 10, 4)
		elif level == 15:
			next_order = spawner_node.spawn_random_shielded_from_list(3, easy_shielded_enemy_list, true, 1)
			next_order = spawner_node.spawn_random_shielded_from_list(3, medium_shielded_enemy_list, true, next_order)
			next_order = spawner_node.spawn_random_shielded_from_list(1, hard_shielded_enemy_list, true, next_order)
			next_order = spawner_node.spawn_random_shielded_from_list(1, boss_shielded_enemy_list, true, next_order, 1000)
						
			spawner_node.spawn_random_from_list(4, small_obstacle_list, false)
			spawner_node.spawn_random_from_list(3, medium_obstacle_list, false)
			spawner_node.spawn_random_from_list(3, large_obstacle_list, false)
			spawner_node.spawn_random_from_list_with_chance(1, powerup_list, false, 10, 4)
		elif level == 20:
			next_order = spawner_node.spawn_random_shielded_from_list(4, easy_shielded_enemy_list, true, 1)
			next_order = spawner_node.spawn_random_shielded_from_list(2, medium_shielded_enemy_list, true, next_order)
			next_order = spawner_node.spawn_random_shielded_from_list(2, hard_shielded_enemy_list, true, next_order)
			next_order = spawner_node.spawn_random_shielded_from_list(1, boss_shielded_enemy_list, true, next_order, 1000)
						
			spawner_node.spawn_random_from_list(5, small_obstacle_list, false)
			spawner_node.spawn_random_from_list(5, medium_obstacle_list, false)
			spawner_node.spawn_random_from_list(4, large_obstacle_list, false)
			spawner_node.spawn_random_from_list_with_chance(1, powerup_list, false, 10, 4)
		elif level == 25:
			next_order = spawner_node.spawn_random_shielded_from_list(3, easy_shielded_enemy_list, true, 1)
			next_order = spawner_node.spawn_random_shielded_from_list(3, medium_shielded_enemy_list, true, next_order)
			next_order = spawner_node.spawn_random_shielded_from_list(3, hard_shielded_enemy_list, true, next_order)
			next_order = spawner_node.spawn_random_shielded_from_list(1, boss_shielded_enemy_list, true, next_order, 1000)
						
			spawner_node.spawn_random_from_list(5, small_obstacle_list, false)
			spawner_node.spawn_random_from_list(5, medium_obstacle_list, false)
			spawner_node.spawn_random_from_list(4, large_obstacle_list, false)
			spawner_node.spawn_random_from_list_with_chance(1, powerup_list, false, 10, 4)
		else:
			next_order = spawner_node.spawn_random_shielded_from_list(3, easy_shielded_enemy_list, true, 1)
			next_order = spawner_node.spawn_random_shielded_from_list(4, medium_shielded_enemy_list, true, next_order)
			next_order = spawner_node.spawn_random_shielded_from_list(3, hard_shielded_enemy_list, true, next_order)
			next_order = spawner_node.spawn_random_shielded_from_list(2, boss_shielded_enemy_list, true, next_order, 1000)
						
			spawner_node.spawn_random_from_list(5, small_obstacle_list, false)
			spawner_node.spawn_random_from_list(5, medium_obstacle_list, false)
			spawner_node.spawn_random_from_list(4, large_obstacle_list, false)
			spawner_node.spawn_random_from_list_with_chance(1, powerup_list, false, 10, 4)
			
		boss_anim_node.stop()
		boss_anim_node.play("Show")
		return true
	else:
		return false

func spawn_objects_for_level(level):
	var is_boss_level = handle_boss_sequence(level)
	var next_order = 0
	
	if !is_boss_level:
		if level > 25:
			spawner_node.spawn_random_from_list(4, easy_enemy_list, true)
			spawner_node.spawn_random_from_list_with_chance(3, medium_enemy_list, true, 10, 8)
			spawner_node.spawn_random_from_list_with_chance(4, hard_enemy_list, true, 10, 8)
			
			next_order = spawner_node.spawn_random_shielded_from_list(2, easy_shielded_enemy_list, true, 1)
			next_order = spawner_node.spawn_random_shielded_from_list(3, medium_shielded_enemy_list, true, next_order)
			next_order = spawner_node.spawn_random_shielded_from_list(2, hard_shielded_enemy_list, true, next_order)
			
			spawner_node.spawn_random_from_list(5, small_obstacle_list, false)
			spawner_node.spawn_random_from_list(5, medium_obstacle_list, false)
			spawner_node.spawn_random_from_list(4, large_obstacle_list, false)
			spawner_node.spawn_random_from_list_with_chance(4, powerup_list, false, 10, 4)
		elif level > 20 && level < 25:
			spawner_node.spawn_random_from_list(4, easy_enemy_list, true)
			spawner_node.spawn_random_from_list_with_chance(3, medium_enemy_list, true, 10, 8)
			spawner_node.spawn_random_from_list_with_chance(3, hard_enemy_list, true, 10, 8)
			
			next_order = spawner_node.spawn_random_shielded_from_list(2, easy_shielded_enemy_list, true, 1)
			next_order = spawner_node.spawn_random_shielded_from_list(2, medium_shielded_enemy_list, true, next_order)
			next_order = spawner_node.spawn_random_shielded_from_list(1, hard_shielded_enemy_list, true, next_order)
			
			spawner_node.spawn_random_from_list(5, small_obstacle_list, false)
			spawner_node.spawn_random_from_list(5, medium_obstacle_list, false)
			spawner_node.spawn_random_from_list(4, large_obstacle_list, false)
			spawner_node.spawn_random_from_list_with_chance(4, powerup_list, false, 10, 4)
		elif level > 10 && level < 20:
			spawner_node.spawn_random_from_list(4, easy_enemy_list, true)
			spawner_node.spawn_random_from_list(2, medium_enemy_list, true)
			spawner_node.spawn_random_from_list_with_chance(2, hard_enemy_list, true, 10, 8)
			
			next_order = spawner_node.spawn_random_shielded_from_list(2, easy_shielded_enemy_list, true, 1)
			next_order = spawner_node.spawn_random_shielded_from_list(2, medium_shielded_enemy_list, true, next_order)
			
			spawner_node.spawn_random_from_list(4, small_obstacle_list, false)
			spawner_node.spawn_random_from_list(3, medium_obstacle_list, false)
			spawner_node.spawn_random_from_list(3, large_obstacle_list, false)
			spawner_node.spawn_random_from_list_with_chance(3, powerup_list, false, 10, 4)
		elif level > 5 && level < 10:
			spawner_node.spawn_random_from_list(4, easy_enemy_list, true)
			spawner_node.spawn_random_from_list(2, medium_enemy_list, true)
			
			next_order = spawner_node.spawn_random_shielded_from_list(2, easy_shielded_enemy_list, true, 1)
			
			spawner_node.spawn_random_from_list(3, small_obstacle_list, false)
			spawner_node.spawn_random_from_list(3, medium_obstacle_list, false)
			spawner_node.spawn_random_from_list(2, large_obstacle_list, false)
			spawner_node.spawn_random_from_list_with_chance(2, powerup_list, false, 10, 4)
		elif level < 5:
			spawner_node.spawn_random_from_list(4, easy_enemy_list, true)
			spawner_node.spawn_random_from_list(1, medium_enemy_list, true)
			spawner_node.spawn_random_from_list(2, small_obstacle_list, false)
			spawner_node.spawn_random_from_list(2, medium_obstacle_list, false)
			spawner_node.spawn_random_from_list(2, large_obstacle_list, false)
			spawner_node.spawn_random_from_list_with_chance(1, powerup_list, false, 10, 4)
			
			if level == 1 and Globals.show_tutorial:
				spawner_node.player_scene.can_shoot = false
				var tutorial1_dialog = Dialogic.start("Tutorial1")
				tutorial1_dialog.connect("timeline_end", self, "tutorial_ended")
				add_child(tutorial1_dialog)

	num_enemies = get_tree().get_nodes_in_group("enemy").size()

func tutorial_ended(timeline_name):
	spawner_node.player_scene.can_shoot = true

func enemy_shoot():
	num_enemies = get_tree().get_nodes_in_group("enemy").size()
	get_tree().call_group("enemy", "shoot", spawner_node.player_scene)

func determine_turn_end():
	num_shots_fired += 1
	if num_shots_fired >= num_enemies:
		num_shots_fired = 0
		if is_instance_valid(spawner_node.player_scene):
			spawner_node.player_scene.set_player_turn(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

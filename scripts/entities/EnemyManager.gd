extends Node

export(NodePath) var spawner
export(Array, PackedScene) var easy_enemy_list
export(Array, PackedScene) var medium_enemy_list
export(Array, PackedScene) var hard_enemy_list
export(Array, PackedScene) var small_obstacle_list
export(Array, PackedScene) var medium_obstacle_list
export(Array, PackedScene) var large_obstacle_list
var spawner_node = null
var num_enemies = 0
var num_shots_fired = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	spawner_node = get_node(spawner)
	if spawner_node == null:
		printerr("Enemy Spawner is not assigned!")
		get_tree().quit()
		
func spawnObjectsForLevel(level):
	spawner_node.spawnRandomFromList(5, easy_enemy_list, true)
	spawner_node.spawnRandomFromList(2, medium_enemy_list, true)
	spawner_node.spawnRandomFromList(5, small_obstacle_list, false)
	spawner_node.spawnRandomFromList(2, medium_obstacle_list, false)
	spawner_node.spawnRandomFromList(2, large_obstacle_list, false)
	
	num_enemies = get_tree().get_nodes_in_group("enemy").size()
	
func enemyShoot():
	num_enemies = get_tree().get_nodes_in_group("enemy").size()
	get_tree().call_group("enemy", "shoot", spawner_node.player_scene)
	
func determineTurnEnd():
	num_shots_fired += 1
	if num_shots_fired >= num_enemies:
		num_shots_fired = 0
		spawner_node.player_scene.player_turn = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

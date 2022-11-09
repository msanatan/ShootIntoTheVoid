extends Area2D

export(PackedScene) var missile
export(PackedScene) var explosion
var player_node = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func shoot(player):
	var spawned_missile = missile.instance()
	get_tree().get_root().add_child(spawned_missile)
	spawned_missile.position = get_position()
	spawned_missile.look_at(player.global_position)
	spawned_missile.player_position = player.global_position
	spawned_missile.connect("enemy_missile_destroyed", self, "_on_EnemyMissile_missile_destroyed")

func _on_EnemyMissile_missile_destroyed(entity):
	var node_name = str(entity.name.replace("@", "").replace(str(int(entity.name)), ""))
	if node_name == "Player":
		entity.decrease_health(10)
		
	var main = get_tree().get_root().get_node("Main")
	if is_instance_valid(main):
		var enemy_manager = main.get_node("EnemyManager")
		if is_instance_valid(enemy_manager):
			enemy_manager.determine_turn_end()

func kill():
	var spawned_explosion = explosion.instance()
	get_tree().get_root().add_child(spawned_explosion)
	spawned_explosion.position = get_position()
	queue_free()
	
func set_player(player):
	player_node = player
	
func _physics_process(delta):
	if is_instance_valid(player_node):
		rotation = (player_node.global_position - global_position).angle() + PI/2

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

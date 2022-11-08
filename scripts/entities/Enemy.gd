extends Area2D

export(PackedScene) var missile

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

func _on_EnemyMissile_missile_destroyed(player):
	player.decreaseHealth(10)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

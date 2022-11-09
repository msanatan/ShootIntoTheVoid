extends Area2D

export(PackedScene) var missile
export(PackedScene) var explosion

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
	var main = get_tree().get_root().get_node("Main")
	if main:
		var enemyManager = main.get_node("EnemyManager")
		if enemyManager:
			enemyManager.determineTurnEnd()

func kill():
	var spawned_explosion = explosion.instance()
	get_tree().get_root().add_child(spawned_explosion)
	spawned_explosion.position = get_position()
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

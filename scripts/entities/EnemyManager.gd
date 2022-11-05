extends Node

export(NodePath) var spawner
var spawner_node = null

# Called when the node enters the scene tree for the first time.
func _ready():
	spawner_node = get_node(spawner)
	if spawner_node == null:
		printerr("Enemy Spawner is not assigned!")
		get_tree().quit()
		
func spawnEnemiesForLevel(level):
	#spawner_node.spawn(100, "res://scenes/entities/enemies/TestEnemy.tscn")
	spawner_node.spawnRandomFromList(20, ["res://scenes/entities/enemies/TestEnemy.tscn", "res://scenes/entities/enemies/TestEnemy2.tscn"])


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

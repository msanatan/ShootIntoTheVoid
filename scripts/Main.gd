extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	$EnemyManager.spawnObjectsForLevel(1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
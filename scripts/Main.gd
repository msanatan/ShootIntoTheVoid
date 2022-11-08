extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	$EnemyManager.spawnObjectsForLevel(1)


func _on_Player_fire_missile():
	$CanvasAnimationPlayer.play("FadeScreenToBlack")

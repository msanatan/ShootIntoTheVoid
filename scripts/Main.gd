extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	$EnemyManager.spawnObjectsForLevel(1)

	$HealthLabel.set_text("HP: "+str($Player.health))
	$ScoreLabel.set_text("Score: 0")
	$Player.connect("health_decreased", self, "_on_Player_health_decreased")
	$Player.connect("score_increased", self, "_on_Player_score_increased")
	$PlayerMovementArea.position = $Player.position
	$PlayerMovementArea.visible = true

func _on_Player_health_decreased(health):
	$HealthLabel.set_text("HP: "+str(health))


func _on_Player_score_increased(score):
	$ScoreLabel.set_text("Score: "+str(score))


func _on_Player_fire_missile():
	$PlayerMovementArea.visible = false
	$CanvasAnimationPlayer.play("FadeScreenToBlack")


func _on_Player_missile_destroyed():
	$PlayerMovementArea.visible = true
	$CanvasAnimationPlayer.play_backwards("FadeScreenToBlack")

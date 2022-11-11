extends Node

export var level = 1
var game_over = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$EnemyManager.spawn_objects_for_level(level)

	$UI/HealthLabel.set_text("LIFE: "+str($Player.health))
	$UI/ScoreLabel.set_text("SCORE: 0")
	$UI/LevelCompleteLabel.hide()
	$UI/GameOverLabel.hide()
	$UI/DemoLabel.hide()
	$UI/RestartButton.hide()
	
	$Player.connect("health_decreased", self, "_on_Player_health_decreased")
	$Player.connect("score_increased", self, "_on_Player_score_increased")
	$PlayerMovementArea.position = $Player.position
	$PlayerMovementArea.visible = true
	$Player.connect("player_turn_started", self, "_on_Player_turn_started")
	$Player.connect("player_turn_ended", self, "_on_Player_turn_ended")
	$Player.connect("level_cleared", self, "_on_level_cleared")
	$Player.connect("player_died", self, "_on_game_over")
	
	show_turn_label("Player Turn")


func _process(_delta):
	if Input.is_action_pressed("toggle_debug_tools"):
		$DebugTools.visible = !$DebugTools.visible


func _on_level_cleared():
	game_over = true
	$UI/LevelCompleteLabel.show()
	$UI/DemoLabel.show()
	$UI/RestartButton.show()
	$UI/TurnLabel.hide()

func _on_game_over():
	game_over = true
	$UI/GameOverLabel.show()
	$UI/DemoLabel.show()
	$UI/RestartButton.show()	
	$UI/TurnLabel.hide()

func _on_Player_health_decreased(health):
	$UI/HealthLabel.set_text("LIFE: "+str(health))

func _on_Player_score_increased(score):
	$UI/ScoreLabel.set_text("SCORE: "+str(score))

func _on_Player_turn_ended():
	$UI/PlayerShotProgress.hide()
	if !game_over:
		$EnemyManager.enemy_shoot()
		show_turn_label("Enemy Turn")
	
func _on_Player_turn_started():
	show_turn_label("Player Turn")
	
func show_turn_label(text):
	$UI/TurnLabel.show()
	$UI/TurnLabel.set_text(text)
	$UI/TurnAnimationPlayer.stop()
	$UI/TurnAnimationPlayer.play("FadeInAndOut")
	
func _on_TurnAnimationPlayer_animation_finished(anim_name):
	if anim_name == "FadeInAndOut":
		$UI/TurnLabel.hide()

func _on_Player_fire_missile():
	$PlayerMovementArea.visible = false
	$CanvasAnimationPlayer.play("FadeScreenToBlack")


func _on_Player_missile_destroyed():
	$PlayerMovementArea.visible = true
	$CanvasAnimationPlayer.play_backwards("FadeScreenToBlack")


func _on_RestartButton_pressed():
	get_tree().reload_current_scene()

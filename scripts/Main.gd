extends Node

export var level = 1

# Called when the node enters the scene tree for the first time.
func _ready():
    $EnemyManager.spawn_objects_for_level(level)

    $HealthLabel.set_text("HP: "+str($Player.health))
    $ScoreLabel.set_text("Score: 0")
    $Player.connect("health_decreased", self, "_on_Player_health_decreased")
    $Player.connect("score_increased", self, "_on_Player_score_increased")
    $PlayerMovementArea.position = $Player.position
    $PlayerMovementArea.visible = true
    $Player.connect("player_turn_ended", self, "_on_Player_turn_ended")
    $Player.connect("level_cleared", self, "_on_level_cleared")
    $Player.connect("player_died", self, "_on_game_over")


func _process(_delta):
    if Input.is_action_pressed("toggle_debug_tools"):
        $DebugTools.visible = !$DebugTools.visible


func _on_level_cleared():
    print("level cleared")


func _on_game_over():
    print("game over")


func _on_Player_health_decreased(health):
    $HealthLabel.set_text("HP: "+str(health))


func _on_Player_score_increased(score):
    $ScoreLabel.set_text("Score: "+str(score))

func _on_Player_turn_ended():
    $EnemyManager.enemy_shoot()


func _on_Player_fire_missile():
    $PlayerMovementArea.visible = false
    $CanvasAnimationPlayer.play("FadeScreenToBlack")


func _on_Player_missile_destroyed():
    $PlayerMovementArea.visible = true
    $CanvasAnimationPlayer.play_backwards("FadeScreenToBlack")

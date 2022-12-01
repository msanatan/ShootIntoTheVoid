extends Node

onready var background_music: AudioStreamPlayer = get_node("/root/BackgroundMusic")
var game_over = false
export(float) var bg_scroll_speed = 10.0
var rand = RandomNumberGenerator.new()
export(AudioStream) var background_music_file
export(AudioStream) var warning_sfx
export(AudioStream) var boss_background_music_file
export(AudioStream) var death_sfx


# Called when the node enters the scene tree for the first time.
func _ready():
	# TODO: centralize this check
	var is_boss_level: bool = Globals.level % 5 == 0

	if is_boss_level:
		background_music.stream = boss_background_music_file
		background_music.play()
	else:
		if (
			not background_music.playing
			or (
				background_music.playing
				and background_music.stream.resource_path != background_music_file.resource_path
			)
		):
			background_music.stream = background_music_file
			background_music.play()

	rand.randomize()
	$EnemyManager.spawn_objects_for_level(Globals.level)
	$UI/HealthLabel.set_text("LIFE: " + str(Globals.health))
	$UI/ScoreLabel.set_text("SCORE: " + str(Globals.score))
	$UI/LevelLabel.set_text("LEVEL: " + str(Globals.level))
	$UI/BossTitleLabel.hide()
	$UI/GameOverLabel.hide()
	$UI/DemoLabel.hide()
	$UI/RestartButton.hide()

	$Player.connect("health_changed", self, "_on_Player_health_changed")
	$Player.connect("score_increased", self, "_on_Player_score_increased")
	$PlayerMovementArea.position = $Player.position
	$PlayerMovementArea.visible = true
	$Player.connect("player_turn_started", self, "_on_Player_turn_started")
	$Player.connect("player_turn_ended", self, "_on_Player_turn_ended")
	$Player.connect("level_cleared", self, "_on_level_cleared")
	$Player.connect("player_died", self, "_on_game_over")

	show_turn_label("Player Turn")

	if Globals.perfect_round:
		Globals.perfect_round = false
		$Player.increase_score(1000, false)
		$Player.show_powerup_message("perfect bonus: +1000!")

	if OS.get_name() == "HTML5":
		$WorldEnvironment.environment.glow_enabled = false


func _process(_delta):
	$ParallaxBackground.scroll_offset.x += bg_scroll_speed * _delta
	$ParallaxBackground.scroll_offset.y += bg_scroll_speed * _delta


func _input(event):
	if Input.is_action_just_pressed("toggle_debug_tools"):
		$DebugTools.visible = !$DebugTools.visible

	if Input.is_action_just_pressed("toggle_glow"):
		$WorldEnvironment.environment.glow_enabled = !$WorldEnvironment.environment.glow_enabled

	if Input.is_action_just_pressed("skip_level") and $DebugTools.visible:
		_on_level_cleared()


func _on_level_cleared():
	Globals.level += 1
	$LevelTransitionTimer.start()
	yield($LevelTransitionTimer, "timeout")
	do_random_transition()
	queue_free()
	get_tree().reload_current_scene()


func do_random_transition():
	var rand_val = rand.randi_range(0, 15)
	match rand_val:
		0:
			FancyFade.noise(self)
		1:
			FancyFade.pixelated_noise(self)
		2:
			FancyFade.blurry_noise(self)
		3:
			FancyFade.cell_noise(self)
		4:
			FancyFade.wipe_left(self)
		5:
			FancyFade.wipe_right(self)
		6:
			FancyFade.wipe_up(self)
		7:
			FancyFade.wipe_down(self)
		8:
			FancyFade.wipe_square(self)
		9:
			FancyFade.wipe_conical(self)
		10:
			FancyFade.circle_in(self)
		11:
			FancyFade.circle_out(self)
		12:
			FancyFade.horizontal_paint_brush(self)
		13:
			FancyFade.vertical_paint_brush(self)
		14:
			FancyFade.swirl(self)
		15:
			FancyFade.tile_reveal(self)


func _on_game_over():
	game_over = true
	$UIAudioStreamPlayer.stream = death_sfx
	$UIAudioStreamPlayer.play()
	$UI/GameOverLabel.show()
	$UI/DemoLabel.show()
	$UI/RestartButton.show()
	$UI/SubmitScoreButton.show()
	$UI/TurnLabel.hide()


func _on_Player_health_changed(health, is_increase):
	$UI/HealthLabel.set_text("LIFE: " + str(health))


func _on_Player_score_increased(score):
	$UI/ScoreLabel.set_text("SCORE: " + str(score))


func _on_Player_turn_ended():
	$UI/PlayerShotProgress.hide()
	$UI/PlayerShotProgress.value = 100
	if !game_over:
		$EnemyManager.enemy_shoot()
		show_turn_label("Enemy Turn")


func _on_Player_turn_started():
	if !game_over:
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
	exit_to_title()


func exit_to_title():
	Globals.level = 1
	Globals.health = 100
	Globals.score = 0
	Globals.perfect_round = false
	queue_free()
	var title_scene = load("res://scenes/Title.tscn")
	FancyFade.horizontal_paint_brush(title_scene.instance())


func _on_SubmitScoreButton_pressed():
	$UI/PlayerNameInput.popup()


func _on_BackButton_pressed():
	$UI/BackButton.disabled = true
	$UI/BackButton.text = "Loading..."
	$UIAudioStreamPlayer.play()
	yield($UIAudioStreamPlayer, "finished")
	if Globals.score > 0:
		$UI/BackButton.disabled = false
		$UI/BackButton.text = ""
		get_tree().paused = true
		$UI/PlayerNameInput.popup()
	else:
		exit_to_title()

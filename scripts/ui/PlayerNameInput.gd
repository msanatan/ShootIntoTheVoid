extends PopupDialog


# Called when the node enters the scene tree for the first time.
func _ready():
	$NameTextEdit.text = Globals.player_name


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_CancelButton_pressed():
	$AudioStreamPlayer.play()
	yield($AudioStreamPlayer, "finished")
	get_tree().paused = false
	hide()


func _on_OkButton_pressed():
	$AudioStreamPlayer.play()
	yield($AudioStreamPlayer, "finished")

	get_tree().paused = false
	Globals.player_name = $NameTextEdit.text
	if Globals.player_name.length() > 10:
		Globals.player_name = Globals.player_name.substr(0, 10)

	if Globals.player_name.length() > 0:
		$OkButton.disabled = true
		var score_id = yield(
			SilentWolf.Scores.persist_score(Globals.player_name, Globals.score), "sw_score_posted"
		)
		hide()
		get_tree().get_root().get_node("Main").exit_to_title()


func _on_QuitButton_pressed():
	$AudioStreamPlayer.play()
	yield($AudioStreamPlayer, "finished")
	get_tree().paused = false
	hide()
	get_tree().get_root().get_node("Main").exit_to_title()

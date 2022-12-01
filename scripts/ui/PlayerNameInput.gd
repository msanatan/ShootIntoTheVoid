extends PopupDialog


# Called when the node enters the scene tree for the first time.
func _ready():
	$NameTextEdit.text = Globals.player_name

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_CancelButton_pressed():
	$CancelButton.disabled = true
	$NameLabel.text = "Loading..."
	$UIAudioStreamPlayer.play()
	yield($UIAudioStreamPlayer, "finished")
	get_tree().paused = false
	$CancelButton.disabled = false
	$NameLabel.text = "Please Enter Your Name"
	hide()


func _on_OkButton_pressed():
	$OkButton.disabled = true
	$NameLabel.text = "Loading..."
	
	$UIAudioStreamPlayer.play()
	yield($UIAudioStreamPlayer, "finished")

	$OkButton.disabled = false
	$NameLabel.text = "Please Enter Your Name"
	
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
	$QuitButton.disabled = true
	$NameLabel.text = "Loading..."
	
	$UIAudioStreamPlayer.play()
	yield($UIAudioStreamPlayer, "finished")
	get_tree().paused = false
	hide()
	$QuitButton.disabled = false
	$NameLabel.text = "Please Enter Your Name"
	
	get_tree().get_root().get_node("Main").exit_to_title()

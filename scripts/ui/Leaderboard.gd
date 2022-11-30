extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	populate()


func populate():
	yield(SilentWolf.Scores.get_high_scores(), "sw_scores_received")

	var index = 1
	var name_format_str = "Panel/Name%dLabel"
	var score_format_str = "Panel/Score%dLabel"
	for score in SilentWolf.Scores.scores:
		var name_node = name_format_str % index
		var score_node = score_format_str % index
		var name_label = get_node(name_node)
		var score_label = get_node(score_node)
		name_label.text = str(index) + ". " + score.player_name
		score_label.text = str(int(score.score))
		index += 1


func _on_RefreshButton_pressed():
	$Panel/RefreshButton.disabled = true
	populate()
	$Panel/RefreshButton.disabled = false

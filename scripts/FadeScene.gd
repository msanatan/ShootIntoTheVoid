extends ColorRect

export(String, FILE, "*.tscn") var next_scene

onready var anim_player := $AnimationPlayer


func _ready() -> void:
	anim_player.play_backwards("Fade")


func transition_to(_next_scene := next_scene) -> void:
	anim_player.play("Fade")
	yield(anim_player, "animation_finished")
	get_tree().change_scene(_next_scene)

extends MarginContainer

onready var fade_scene := $FadeScene


func _on_Timer_timeout():
	fade_scene.transition_to()

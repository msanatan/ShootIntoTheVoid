extends Node2D

var main_scene = load("res://scenes/Main.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	modulate.a = 0
	$TitleAnimationPlayer.play("FadeIn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	FancyFade.horizontal_paint_brush(main_scene.instance())

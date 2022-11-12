extends Node2D

var main_scene = preload("res://scenes/Main.tscn")
export (float) var bg_scroll_speed = 10.0

# Called when the node enters the scene tree for the first time.
func _ready():
	modulate.a = 0
	$TitleAnimationPlayer.play("FadeIn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$ParallaxBackground.scroll_offset.x += bg_scroll_speed * delta
	$ParallaxBackground.scroll_offset.y += bg_scroll_speed * delta


func _on_Button_pressed():
	FancyFade.horizontal_paint_brush(main_scene.instance())

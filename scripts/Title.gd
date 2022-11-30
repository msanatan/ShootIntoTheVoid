extends Node2D

onready var background_music: AudioStreamPlayer = get_node("/root/BackgroundMusic")
var main_scene = preload("res://scenes/Main.tscn")
export(float) var bg_scroll_speed = 10.0
export(AudioStream) var background_music_file


# Called when the node enters the scene tree for the first time.
func _ready():
    modulate.a = 0
    background_music.stream = background_music_file
    background_music.play()
    $TitleAnimationPlayer.play("FadeIn")
    $TutorialCheckBox.pressed = Globals.first_time


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    $ParallaxBackground.scroll_offset.x += bg_scroll_speed * delta
    $ParallaxBackground.scroll_offset.y += bg_scroll_speed * delta


func _on_Button_pressed():
    Globals.first_time = false
    Globals.show_tutorial = $TutorialCheckBox.pressed
    queue_free()
    FancyFade.horizontal_paint_brush(main_scene.instance())

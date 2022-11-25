extends Node

var level = 1
var health = 100
var score = 0
var player_name = ""
var first_time = true
var show_tutorial = true


# Called when the node enters the scene tree for the first time.
func _ready():
	SilentWolf.configure({
		"api_key": "w4I7LWbhYl9Lr3lFon4X29DC8LCSnArQ84Mp4u1Y",
		"game_id": "ShootIntoTheVoid",
		"game_version": "1.0.0",
		"log_level": 1
	})

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

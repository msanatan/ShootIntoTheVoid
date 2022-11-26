extends Area2D

export(PackedScene) var explosion
export(String) var powerup_type


# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.


func collect(player):
	var spawned_explosion = explosion.instance()
	get_tree().get_root().add_child(spawned_explosion)
	spawned_explosion.position = get_position()
	apply_powerup(player)
	queue_free()


func apply_powerup(player):
	match powerup_type:
		"health":
			player.increase_health(50)
			player.show_powerup_message("life up!")
		"score":
			player.increase_score(250)
			player.show_powerup_message("bonus points!")
		"speed":
			player.change_missile_speed(400)
			player.show_powerup_message("speed boost!")
		"beacon":
			player.change_light_scale(1.6)
			player.show_powerup_message("beacon!")
		"illuminate":
			player.change_missile_light_scale(0.8)
			player.show_powerup_message("illuminate!")
		"ghost":
			player.apply_ghost_shot(0.2)
			player.show_powerup_message("ghost shot!")
		"time5":
			player.extend_shot_timer(5)
			player.show_powerup_message("time extended +5!")
		"time10":
			player.extend_shot_timer(10)
			player.show_powerup_message("time extended +10!")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

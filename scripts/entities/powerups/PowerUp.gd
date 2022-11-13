extends Area2D

export(PackedScene) var explosion
export(String) var powerup_type

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

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
			player.power_up_label_node.set_text("life up!")
			player.power_up_animation_node.stop()
			player.power_up_animation_node.play("Show")
		"score":
			player.increase_score(250)
			player.power_up_label_node.set_text("bonus points!")
			player.power_up_animation_node.stop()
			player.power_up_animation_node.play("Show")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

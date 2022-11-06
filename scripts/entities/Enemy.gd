extends Area2D

export(PackedScene) var missile

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func shoot(player_position):
	var spawned_missile = missile.instance()
	get_tree().get_root().add_child(spawned_missile)
	spawned_missile.position = get_position()
	spawned_missile.look_at(player_position)
	spawned_missile.player_position = player_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

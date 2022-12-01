extends Area2D

export(PackedScene) var missile
export(PackedScene) var explosion
export(int) var points

var player_node = null
var is_shielded = false
var is_ordered = false
var order_num = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	is_shielded = $Shield.visible
	is_ordered = $OrderLabel.visible


func apply_shield(order):
	if order == 1:
		$Shield.hide()
		is_shielded = false
	else:
		$Shield.show()
		is_shielded = true

	$OrderLabel.show()
	$OrderLabel.text = str(order)
	order_num = order
	is_ordered = true


func shoot(player):
	$AudioStreamPlayer.pitch_scale = rand_range(0.8, 1.2)
	$AudioStreamPlayer.play()
	var spawned_missile = missile.instance()
	get_tree().get_root().add_child(spawned_missile)
	spawned_missile.position = get_position()
	spawned_missile.look_at(player.global_position)
	spawned_missile.player_position = player.global_position
	spawned_missile.connect("enemy_missile_destroyed", self, "_on_EnemyMissile_missile_destroyed")


func _on_EnemyMissile_missile_destroyed(entity, damage):
	var node_name = str(entity.name.replace("@", "").replace(str(int(entity.name)), ""))
	if node_name == "Player":
		entity.decrease_health(damage)

	var main = get_tree().get_root().get_node("Main")
	if is_instance_valid(main):
		var enemy_manager = main.get_node("EnemyManager")
		if is_instance_valid(enemy_manager):
			enemy_manager.determine_turn_end()


func determine_next_in_order(next):
	if order_num == next:
		$Shield.hide()
		is_shielded = false


func kill():
	if is_ordered:
		get_tree().call_group("enemy", "determine_next_in_order", order_num + 1)

	var spawned_explosion = explosion.instance()
	get_tree().get_root().add_child(spawned_explosion)
	spawned_explosion.position = get_position()
	spawned_explosion.emitting = true
	queue_free()


func set_player(player):
	player_node = player


func _physics_process(delta):
	if is_instance_valid(player_node):
		rotation = (player_node.global_position - global_position).angle() + PI / 2
		$OrderLabel.rect_pivot_offset = $OrderLabel.rect_size / 2
		$OrderLabel.set_rotation(-rotation)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

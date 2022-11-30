extends KinematicBody2D

signal fire_missile
signal missile_destroyed
signal health_changed
signal player_died
signal score_increased
signal player_turn_started
signal player_turn_ended
signal level_cleared

export(PackedScene) var missile
export(PackedScene) var explosion
export(NodePath) var shot_progress_bar
export(NodePath) var power_up_label
export(NodePath) var power_up_animation
export(NodePath) var shake_camera
export var speed = 150
export(bool) var can_shoot = true

var shot_progress_bar_node: TextureProgress = null
var power_up_label_node = null
var power_up_animation_node = null
var shake_camera_node = null
var spawned_missile = null

var is_shooting := false
var player_turn := true
var velocity := Vector2.ZERO
var enemies_hit_this_turn := 0
var total_enemies_this_turn := 0
var total_enemies_for_level := 0


func _ready():
	shot_progress_bar_node = get_node(shot_progress_bar)
	power_up_label_node = get_node(power_up_label)
	power_up_animation_node = get_node(power_up_animation)
	shake_camera_node = get_node(shake_camera)
	can_shoot = true

	$Light2D.scale = Vector2(0.2, 0.2)


func _input(event):
	if event.is_action_pressed("attack") and player_turn and can_shoot and not is_shooting:
		print_debug("Firing missile")
		is_shooting = true
		enemies_hit_this_turn = 0
		total_enemies_this_turn = get_tree().get_nodes_in_group("enemy").size()
		$ChargingParticles.emitting = true
		emit_signal("fire_missile")
		$AnimationPlayer.play("LightsOn")


func _physics_process(delta):
	if not is_shooting and player_turn:
		velocity = Vector2.ZERO
		look_at(get_global_mouse_position())

		if Input.is_action_pressed("move_left"):
			velocity.x -= 1
		elif Input.is_action_pressed("move_right"):
			velocity.x += 1
		elif Input.is_action_pressed("move_up"):
			velocity.y -= 1
		elif Input.is_action_pressed("move_down"):
			velocity.y += 1

		move_and_collide(velocity.normalized() * speed * delta)


func do_normal_shake():
	shake_camera_node.NOISE_SHAKE_SPEED = 30.0
	shake_camera_node.NOISE_SHAKE_STRENGTH = 10.0
	shake_camera_node.SHAKE_DECAY_RATE = 3.0
	shake_camera_node.apply_noise_shake()


func _on_PlayerMissile_missile_destroyed():
	is_shooting = false
	player_turn = false

	do_normal_shake()

	emit_signal("missile_destroyed")
	$AnimationPlayer.play("LightsOff")


func _on_AnimationPlayer_animation_finished(anim_name: String):
	if anim_name == "LightsOn":
		shot_progress_bar_node.show()
		shot_progress_bar_node.value = 100
		spawned_missile = missile.instance()
		get_tree().get_root().add_child(spawned_missile)
		spawned_missile.speed = 250
		spawned_missile.is_ghost_shot = false
		spawned_missile.position = $BulletSpawnPoint.global_position
		spawned_missile.look_at(get_global_mouse_position())
		spawned_missile.set_shot_progress_bar(shot_progress_bar_node)
		spawned_missile.connect("missile_destroyed", self, "_on_PlayerMissile_missile_destroyed")
		spawned_missile.connect("enemy_hit", self, "_on_PlayerMissile_enemy_hit")
		spawned_missile.connect("powerup_hit", self, "_on_PlayerMissile_powerup_hit")
		$ChargingParticles.emitting = false
		do_normal_shake()
	elif anim_name == "LightsOff":
		emit_signal("player_turn_ended")


func _on_PlayerMissile_powerup_hit(powerup, missile):
	do_normal_shake()
	powerup.collect(self)


func _on_PlayerMissile_enemy_hit(enemy, missile):
	increase_score(enemy.points)
	enemy.kill()

	do_normal_shake()

	enemies_hit_this_turn += 1

	if enemies_hit_this_turn == total_enemies_this_turn:
		missile.queue_free()
		emit_signal("level_cleared")

	if enemies_hit_this_turn == total_enemies_for_level:
		Globals.perfect_round = true


func show_powerup_message(message):
	power_up_label_node.set_text(message)
	power_up_animation_node.stop()
	power_up_animation_node.play("Show")


func increase_score(amount, show_message = true):
	Globals.score += amount
	if show_message:
		show_powerup_message("+" + str(amount))
	emit_signal("score_increased", Globals.score)


func set_player_turn(turn):
	player_turn = turn
	emit_signal("player_turn_started")


func decrease_health(amount):
	Globals.health -= amount
	if Globals.health <= 0:
		shake_camera_node.NOISE_SHAKE_SPEED = 30.0
		shake_camera_node.SHAKE_DECAY_RATE = 3.0
		shake_camera_node.NOISE_SHAKE_STRENGTH = 200.0
		shake_camera_node.apply_noise_shake()

		Globals.health = 0
		emit_signal("player_died")
		var spawned_explosion = explosion.instance()
		spawned_explosion.emitting = true
		get_tree().get_root().add_child(spawned_explosion)
		spawned_explosion.position = get_position()
		get_tree().call_group("enemy_missile", "hide")
		queue_free()
	else:
		shake_camera_node.NOISE_SHAKE_SPEED = 30.0
		shake_camera_node.SHAKE_DECAY_RATE = 3.0
		shake_camera_node.NOISE_SHAKE_STRENGTH = 60.0
		shake_camera_node.apply_noise_shake()

	emit_signal("health_changed", Globals.health, false)


func increase_health(amount):
	Globals.health += amount
	emit_signal("health_changed", Globals.health, true)


func change_missile_speed(new_speed, duration = 3):
	if is_instance_valid(spawned_missile):
		var prev_speed = spawned_missile.speed
		spawned_missile.speed = new_speed
		yield(get_tree().create_timer(duration), "timeout")
		if is_instance_valid(spawned_missile):
			spawned_missile.speed = prev_speed


func change_light_scale(new_scale, duration = 5):
	var prev_scale = $Light2D.scale
	$Light2D.scale = Vector2(new_scale, new_scale)
	yield(get_tree().create_timer(duration), "timeout")
	$Light2D.scale = prev_scale


func change_missile_light_scale(new_scale, duration = 5):
	if is_instance_valid(spawned_missile):
		var light = spawned_missile.get_node("Light2D")
		var prev_scale = light.scale
		light.scale = Vector2(new_scale, new_scale)
		yield(get_tree().create_timer(duration), "timeout")
		if is_instance_valid(spawned_missile):
			light.scale = prev_scale


func apply_ghost_shot(alpha, duration = 5):
	if is_instance_valid(spawned_missile):
		var prev_alpha = spawned_missile.modulate.a
		spawned_missile.modulate.a = alpha
		spawned_missile.is_ghost_shot = true
		yield(get_tree().create_timer(duration), "timeout")
		if is_instance_valid(spawned_missile):
			spawned_missile.modulate.a = prev_alpha
			spawned_missile.is_ghost_shot = false


func extend_shot_timer(amount):
	if is_instance_valid(spawned_missile):
		spawned_missile.extend_destroy_timer(5)

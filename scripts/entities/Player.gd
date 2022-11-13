extends KinematicBody2D

signal fire_missile
signal missile_destroyed
signal health_changed
signal player_died
signal score_increased
signal player_turn_started
signal player_turn_ended
signal level_cleared

export (PackedScene) var missile
export (PackedScene) var explosion
export (NodePath) var shot_progress_bar
export (NodePath) var power_up_label
export (NodePath) var power_up_animation

var shot_progress_bar_node = null
var power_up_label_node = null
var power_up_animation_node = null
export var speed = 150
var is_shooting = false
var player_turn = true
var velocity = Vector2.ZERO
var enemies_hit_this_turn = 0
var total_enemies_this_turn = 0

func _ready():
	shot_progress_bar_node = get_node(shot_progress_bar)
	power_up_label_node = get_node(power_up_label)
	power_up_animation_node = get_node(power_up_animation)

func _input(event):
	if event.is_action_pressed("attack") and player_turn and not is_shooting:
		print_debug("Firing missile")
		is_shooting = true
		enemies_hit_this_turn = 0
		total_enemies_this_turn = get_tree().get_nodes_in_group("enemy").size()
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


func _on_PlayerMissile_missile_destroyed():
	is_shooting = false
	player_turn = false
	emit_signal("missile_destroyed")
	$AnimationPlayer.play("LightsOff")


func _on_AnimationPlayer_animation_finished(anim_name:String):
	if anim_name == "LightsOn":
		
		shot_progress_bar_node.show()
		shot_progress_bar_node.value = 100
		
		var spawned_missile = missile.instance()
		get_tree().get_root().add_child(spawned_missile)
		spawned_missile.position = $BulletSpawnPoint.global_position
		spawned_missile.look_at(get_global_mouse_position())
		spawned_missile.set_shot_progress_bar(shot_progress_bar_node)
		spawned_missile.connect("missile_destroyed", self, "_on_PlayerMissile_missile_destroyed")
		spawned_missile.connect("enemy_hit", self, "_on_PlayerMissile_enemy_hit")
		spawned_missile.connect("powerup_hit", self, "_on_PlayerMissile_powerup_hit")
	elif anim_name == "LightsOff":
		emit_signal("player_turn_ended")

func _on_PlayerMissile_powerup_hit(powerup, missile):
	powerup.collect(self)

func _on_PlayerMissile_enemy_hit(enemy, missile):
	enemy.kill()
	increase_score(100)

	enemies_hit_this_turn += 1

	if enemies_hit_this_turn == total_enemies_this_turn:
		missile.queue_free()
		emit_signal("level_cleared")

func increase_score(amount):
	Globals.score += amount
	emit_signal("score_increased", Globals.score)
	
func set_player_turn(turn):
	player_turn = turn;
	emit_signal("player_turn_started")

func decrease_health(amount):
	Globals.health -= amount
	if Globals.health <= 0:
		Globals.health = 0
		emit_signal("player_died")
		var spawned_explosion = explosion.instance()
		get_tree().get_root().add_child(spawned_explosion)
		spawned_explosion.position = get_position()
		get_tree().call_group("enemy_missile", "hide")
		queue_free()

	emit_signal("health_changed", Globals.health)
	
func increase_health(amount):
	Globals.health += amount
	emit_signal("health_changed", Globals.health)

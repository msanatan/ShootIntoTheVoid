extends KinematicBody2D

signal fire_missile
signal missile_destroyed
signal health_decreased
signal player_died
signal score_increased

export (PackedScene) var missile
export var health = 100
export var speed = 150
var is_shooting = false
var score = 0
var velocity = Vector2.ZERO

func _input(event):
	if event.is_action_pressed("attack") and not is_shooting:
		print_debug("Firing missile")
		is_shooting = true
		emit_signal("fire_missile")
		$AnimationPlayer.play("LightsOn")


func _physics_process(delta):
	if not is_shooting:
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
	emit_signal("missile_destroyed")
	$AnimationPlayer.play("LightsOff")


func _on_AnimationPlayer_animation_finished(anim_name:String):
	if anim_name == "LightsOn":
		var spawned_missile = missile.instance()
		get_tree().get_root().add_child(spawned_missile)
		spawned_missile.position = $BulletSpawnPoint.global_position
		spawned_missile.look_at(get_global_mouse_position())
		spawned_missile.connect("missile_destroyed", self, "_on_PlayerMissile_missile_destroyed")
		spawned_missile.connect("enemy_hit", self, "_on_PlayerMissile_enemy_hit")

func _on_PlayerMissile_enemy_hit(enemy):
	enemy.kill()
	increaseScore(100)

func increaseScore(amount):
	score += amount
	emit_signal("score_increased", score)

func decreaseHealth(amount):
	health -= amount
	emit_signal("health_decreased", health)

	if health < 0:
		health = 0
		emit_signal("player_died")

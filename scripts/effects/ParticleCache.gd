extends CanvasLayer

var enemy_explosion = preload("res://entities/effects/materials/EnemyExplosion.tres")
var enemy_projectile_explosion = preload("res://entities/effects/materials/EnemyProjectileExplosion.tres")
var player_projectile_explosion = preload("res://entities/effects/materials/PlayerProjectileExplosion.tres")
var thruster = preload("res://entities/effects/materials/Thruster.tres")

var materials = [enemy_explosion, enemy_projectile_explosion, player_projectile_explosion, thruster]


# Called when the node enters the scene tree for the first time.
func _ready():
	for material in materials:
		var particle_instance = Particles2D.new()
		particle_instance.set_process_material(material)
		particle_instance.set_one_shot(true)
		particle_instance.set_modulate(Color(1, 1, 1, 0))
		particle_instance.set_emitting(true)
		self.add_child(particle_instance)

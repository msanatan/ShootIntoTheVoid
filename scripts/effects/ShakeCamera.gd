extends Camera2D

export var decay = 0.3  # How quickly the shaking stops [0, 1].
export var max_offset = Vector2(100, 75)  # Maximum hor/ver shake in pixels.
export var max_roll = 0.1  # Maximum rotation in radians (use sparingly).

var trauma = 0.0  # Current shake strength.
var trauma_power = 3  # Trauma exponent. Use [2, 3].

var rand = RandomNumberGenerator.new()
onready var noise = OpenSimplexNoise.new()
var noise_y = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	global_position = get_viewport_rect().size/2
	rand.randomize()
	noise.seed = rand.randi()
	noise.period = 4
	noise.octaves = 2

func add_trauma(amount):
	trauma = min(trauma + amount, 1.0)

func _process(delta):
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake()
		
func shake():
	noise_y += 1
	var amount = pow(trauma, trauma_power)
	rotation = max_roll * amount * noise.get_noise_2d(noise.seed, noise_y)
	offset.x = max_offset.x * amount * noise.get_noise_2d(noise.seed*2, noise_y)
	offset.y = max_offset.y * amount * noise.get_noise_2d(noise.seed*3, noise_y)

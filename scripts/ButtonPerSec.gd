extends Button

@onready var console: Label = get_parent().get_parent().get_node("Console")
@onready var texture: TextureRect = $"../ButtonPerSec/TextureRect"
@onready var display: Label = $PerSecDisplay
var sound_effect_scene: PackedScene = preload("res://src/scenes/click.tscn")
#----------------
# SHAKE VARIABLES
@export var randomStrength: float = 2.0
@export var shakeFade: float = 5.0
@export var shakeDuration: float = 0.6  # Duration of the shake in seconds

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var shake_strength: float = 0.0
var shake_time: float = 0.0  # Time elapsed since shake started
var is_shaking: bool = false
var last_shake_points: int = 0
var offset: Vector2 = Vector2.ZERO
var original_position: Vector2  # Store the original position
#----------------
var gain_cost: float = 100
var cost_factor: float = 1.25

func _ready() -> void:
	pressed.connect(_button_pressed)
	original_position = Vector2(7, 7)

func _process(delta: float) -> void:
	PlayerVariables.points += PlayerVariables.units_per_second * delta
#----------------
# SHAKE FUNCTION CALLS
	if is_shaking:
		if shake_time < shakeDuration:
			shake_time += delta
			shake_strength = lerp(randomStrength, 0.0, shake_time / shakeDuration)
			offset = randomOffset()
			# Apply the offset to the TextureRect's position
			texture.position = original_position + offset  # Use the original position
		else:
			shake_strength = 0.0
			offset = Vector2.ZERO
			is_shaking = false
			# Reset the TextureRect's position to original
			texture.position = original_position  # Reset to the stored original position
#----------------

func _button_pressed() -> void:
	if PlayerVariables.points >= gain_cost:
		PlayerVariables.points -= gain_cost
		PlayerVariables.units_per_second += 1
		gain_cost = gain_cost * 1.5
		if OS.is_debug_build():
			print("Your units per second are: " + str(round(PlayerVariables.units_per_second)) + ".")
		console.text = "Your units per second are: " + str(round(PlayerVariables.units_per_second)) + "."
		display.text = "x" + (str(format_large_number(PlayerVariables.units_per_second)))
		apply_shake()
		play_sound_effect()
		PlayerVariables.achievement()
#----------------
# SHAKE FUNCTIONS
func apply_shake() -> void:
	shake_strength = randomStrength
	shake_time = 0.0  # Reset the shake time
	is_shaking = true
	#print("Shaking!")

func randomOffset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))
#----------------

#----------------
# ORDERS OF MAGNITUDE
func format_large_number(number: float) -> String:
	var formatted_number: float = 0.0
	if number >= 1e12:
		formatted_number = number / 1e12
		return str(round(formatted_number * 100) / 100) + "T"
	elif number >= 1e9:
		formatted_number = number / 1e9
		return str(round(formatted_number * 100) / 100) + "B"
	elif number >= 1e6:
		formatted_number = number / 1e6
		return str(round(formatted_number * 100) / 100) + "M"
	elif number >= 1e3:
		formatted_number = number / 1e3
		return str(round(formatted_number * 100) / 100) + "K"
	elif number >= 1e0:
		formatted_number = number / 1e0
		return str(round(formatted_number))
	else:
		return str(number)
#----------------

#----------------
# SOUND EFFECT
func play_sound_effect() -> void:
	# Create an instance of the SoundEffect scene
	var sound_instance: Node = sound_effect_scene.instantiate()
	# Add the instance to the current scene
	add_child(sound_instance)
	# Play the sound
	sound_instance.play_sound()
#----------------

extends Button

@onready var console: Label = get_parent().get_parent().get_node("Console")
var sound_effect_scene: PackedScene = preload("res://src/scenes/click.tscn")
var backgrounds_purchased: bool = false
@onready var texture_rect: TextureRect = $"../../../NoiseBG"
@onready var texture: TextureRect = $TextureRect
@onready var noise_texture: NoiseTexture2D = texture_rect.texture
var current_color_index: int = 1

# Dictionary to store numbered color presets
var color_presets: Dictionary = {
	"color 1": [
		Color(0.05, 0.05, 0.05, 1),
		Color(0.12, 0.12, 0.12, 1),
		Color(1, 1, 1, 1)
	],
	"color 2": [
		Color(0.2, 0.2, 0.2, 1),
		Color(0.3, 0.3, 0.3, 1),
		Color(1, 1, 1, 1)
	],
	"color 3": [
		Color(0.2, 0.4, 0.4, 1),
		Color(0.3, 0.5, 0.5, 1),
		Color(1, 1, 1, 1)
	],
	"color 4": [
		Color(0.4, 0.2, 0.2, 1),
		Color(0.5, 0.3, 0.3, 1),
		Color(1, 1, 1, 1)
	],
	"color 5": [
		Color(0.2, 0.2, 0.4, 1),
		Color(0.3, 0.3, 0.5, 1),
		Color(1, 1, 1, 1)
	],
	"color 6": [
		Color(0.4, 0.4, 0.2, 1),
		Color(0.5, 0.5, 0.3, 1),
		Color(1, 1, 1, 1)
	],
	"color 7": [
		Color(0.3, 0.2, 0.4, 1),
		Color(0.4, 0.3, 0.5, 1),
		Color(1, 1, 1, 1)
	],
	"color 8": [
		Color(0.2, 0.4, 0.3, 1),
		Color(0.3, 0.5, 0.4, 1),
		Color(1, 1, 1, 1)
	],
	"color 9": [
		Color(0.4, 0.3, 0.2, 1),
		Color(0.5, 0.4, 0.3, 1),
		Color(1, 1, 1, 1)
	],
	"color 10": [
		Color(0.3, 0.4, 0.2, 1),
		Color(0.4, 0.5, 0.3, 1),
		Color(1, 1, 1, 1)
	]
}

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

func _ready():
	if PlayerVariables.backgrounds == true:
		backgrounds_purchased = true
	current_color_index = PlayerVariables.current_bg
	var color_key = "color " + str(current_color_index)
	change_background(color_key, 0, 1, 2)
	original_position = Vector2(7, 7)

func _process(delta: float) -> void:
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
	pass

func _on_toggled(toggled_on: bool) -> void:
	if not backgrounds_purchased and PlayerVariables.points >= 10000:
		print("Background purchased.")
		console.text = "Background purchased!"
		PlayerVariables.backgrounds = true
		backgrounds_purchased = true
		PlayerVariables.achievement()
		PlayerVariables.points -= 10000
		play_sound_effect()
		change_background("color 1", 0, 1, 2)
		PlayerVariables.current_bg = current_color_index
		apply_shake()

	elif backgrounds_purchased:
		current_color_index = (current_color_index % 10) + 1
		var color_key = "color " + str(current_color_index)
		print("Background switched.")
		console.text = "Background switched to " + color_key + "."
		play_sound_effect()
		change_background(color_key, 0, 1, 2)
		PlayerVariables.current_bg = current_color_index
	elif not backgrounds_purchased and PlayerVariables.points < 10000:
		print("You couldn't purchase backgrounds.")
		console.text = "You couldn't purchase backgrounds.\nThey cost 10K units."
		play_sound_effect()

func play_sound_effect() -> void:
	# Create an instance of the SoundEffect scene
	var sound_instance: Node = sound_effect_scene.instantiate()
	# Add the instance to the current scene
	add_child(sound_instance)
	# Play the sound
	sound_instance.play_sound()

func change_background(color_name: String, index0: int, index1: int, index2: int) -> void:
	# Ensure the texture is a NoiseTexture2D
	if not noise_texture is NoiseTexture2D:
		print("Error: Texture is not a NoiseTexture2D")
		return

	# Check if the color name exists in our presets
	if color_name not in color_presets:
		print("Error: Color preset not found")
		return

	var new_colors = color_presets[color_name]

	# Get the current color ramp
	var gradient: Gradient = noise_texture.color_ramp
	
	# If there's no color ramp, create a new one
	if not gradient:
		gradient = Gradient.new()
		gradient.add_point(0, new_colors[0])
		gradient.add_point(0.5, new_colors[1])
		gradient.add_point(1, new_colors[2])
		noise_texture.color_ramp = gradient
	else:
		gradient.set_color(0, new_colors[0])
		gradient.set_color(1, new_colors[1])
		gradient.set_color(2, new_colors[2])

	# Force the texture to update
	noise_texture.changed.emit()

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

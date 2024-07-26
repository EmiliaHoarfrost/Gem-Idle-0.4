extends Button

var master_bus_index: int = AudioServer.get_bus_index("Master")
@onready var console: Label = get_parent().get_parent().get_node("Console")
var sound_effect_scene: PackedScene = preload("res://src/scenes/click.tscn")

func _on_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		print("Mute button enabled!")
		console.text = "You muted the sound."
		AudioServer.set_bus_mute(master_bus_index, toggled_on)
	if toggled_on == false:
		print("Mute button disabled!")
		console.text = "You unmuted the sound."
		AudioServer.set_bus_mute(master_bus_index, false)
		play_sound_effect()

func play_sound_effect() -> void:
	# Create an instance of the SoundEffect scene
	var sound_instance: Node = sound_effect_scene.instantiate()
	# Add the instance to the current scene
	add_child(sound_instance)
	# Play the sound
	sound_instance.play_sound()

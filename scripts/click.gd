extends AudioStreamPlayer

@export var click: AudioStreamPlayer = self

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Ensure the audio doesn't loop
	self.stream.loop = false
	
	# Connect the finished signal to queue_free
	self.finished.connect(queue_free)

# Function to play the sound effect
func play_sound() -> void:
	# Play the audio
	self.play()

# This function is not necessary unless you need per-frame updates
# func _process(delta):
#     pass

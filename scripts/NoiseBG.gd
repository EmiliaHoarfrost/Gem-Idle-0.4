extends TextureRect

# Speed of texture animation
@export var speed: float = 20.0

var offset: Vector2 = Vector2()
var initial_position: Vector2 = Vector2()
var elapsed_time: float = 0.0  # Time tracker
var animation_duration: float = 10.0  # Duration for the animation to complete

func _ready() -> void:
	initial_position = position  # Set initial position when the scene starts

func _process(delta: float) -> void:
	elapsed_time += delta  # Accumulate elapsed time
	offset.x += speed * delta  # Update the offset based on speed

	# Apply the offset to the texture position
	position = initial_position + offset

	# Check if the animation duration has been reached
	if elapsed_time >= animation_duration:
		position = initial_position  # Reset position to initial
		offset = Vector2()  # Reset offset to zero
		elapsed_time = 0.0  # Reset elapsed time

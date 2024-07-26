extends HBoxContainer

@onready var label1: Label = $UnitDisplay
@onready var label2: Label = $GainDisplay
@onready var label3: Label = $PerSecDisplay
@onready var label4: Label = $LuckDisplay

var vector_value: Vector2 = Vector2(40, 40)
var max_label_width: float = 120  # Set a consistent max width for all labels

func _ready() -> void:
	update_all_labels(vector_value)

func update_all_labels(value: Vector2) -> void:
	# Convert Vector2 to string format for all labels
	var display_text = ""
	
	# Update each label with the same text
	label1.text = display_text 
	label2.text = display_text
	label3.text = display_text
	label4.text = display_text

	# Set constraints for each label to ensure they all have the same max width
	set_label_constraints(label1, max_label_width)
	set_label_constraints(label2, max_label_width)
	set_label_constraints(label3, max_label_width)
	set_label_constraints(label4, max_label_width)

func set_label_constraints(label: Label, max_width: float) -> void:
	# Create a container to manage the maximum width
	var container = Control.new()
	container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	container.size_flags_vertical = Control.SIZE_SHRINK_CENTER

	# Add the label to the container
	container.add_child(label)

	# Add the container to the parent (HBoxContainer)
	add_child(container)

	# Use a signal to enforce maximum width
	container.connect("size_changed", Callable(self, "_on_size_changed").bind(container, max_width))

func _on_size_changed(container: Control, max_width: float) -> void:
	if container.rect_size.x > max_width:
		container.rect_size.x = max_width

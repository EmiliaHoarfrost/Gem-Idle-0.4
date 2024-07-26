extends Label

var score: Label = self
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	update_score_label()

func update_score_label() -> void:
	score.text = "Score: " + (str(format_large_number(PlayerVariables.points)))

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

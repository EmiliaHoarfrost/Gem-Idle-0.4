extends Node

var player_points: float = PlayerVariables.points
var player_units_per_sec: float = PlayerVariables.units_per_second
var player_units_per_click: int = PlayerVariables.points_per_click
var player_luck: float = PlayerVariables.luck
var player_playtime: float = PlayerVariables.playtime
var player_achievements: Dictionary = PlayerVariables.achievements
var player_backgrounds: bool = PlayerVariables.backgrounds
var player_current_bg: int = PlayerVariables.current_bg

const SAVE_GAME_PATH: String = "user://savegame.json"

func write_savegame() -> void:
#region VARIABLES UPDATE
#---------------
# REASSIGNING/UPDATING VARIABLES TO BE SAVED ON SAVE FUNCTION CALL
	var update_player_points: float = PlayerVariables.points
	var update_player_units_per_sec: float = PlayerVariables.units_per_second
	var update_player_units_per_click: int = PlayerVariables.points_per_click
	var update_player_luck: float = PlayerVariables.luck
	var update_player_playtime: float = PlayerVariables.playtime
	var update_player_achievements: Dictionary = PlayerVariables.achievements
	var update_player_backgrounds: bool = PlayerVariables.backgrounds
	var update_player_current_bg: int = PlayerVariables.current_bg
#---------------
#endregion
	var save_data: Dictionary = {
		"player_points": update_player_points,
		"player_units_per_sec": update_player_units_per_sec,
		"player_units_per_click": update_player_units_per_click,
		"player_luck": update_player_luck,
		"playtime": update_player_playtime,
		"player_achievements": update_player_achievements,
		"player_backgrounds": update_player_backgrounds,
		"player_current_bg": update_player_current_bg
	}
	
	# Convert the data to JSON string
	var json_string: String = JSON.stringify(save_data, "\t")
	
	# Open the file for writing
	var file: FileAccess = FileAccess.open(SAVE_GAME_PATH, FileAccess.WRITE)
	if file:
		file.store_string(json_string)  # Store the JSON string in the file
		printerr("Data saved.")
		file.close()  # Close the file
		file = null
	else:
		print("Failed to open file for writing.")

func load_savegame() -> Dictionary:
	var save_data: Dictionary = {}  # Initialize an empty dictionary

	# Open the file for reading
	var file: FileAccess = FileAccess.open(SAVE_GAME_PATH, FileAccess.READ)
	if file:
		var json_string: String = file.get_as_text()  # Read the JSON string from the file
		var json: JSON = JSON.new()  # Create a new JSON instance
		var parse_result: Error = json.parse(json_string)  # Parse the JSON string
		if parse_result == OK:
			save_data = json.data  # Get the parsed data
			printerr("Data loaded.")
		else:
			printerr("Failed to parse JSON: ", json.get_error_message())
		file.close()  # Close the file
		file = null
	else:
		printerr("Failed to open file for reading.")
	
	return save_data  # Return the loaded data

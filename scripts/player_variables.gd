extends Node

var points: float = 0
var points_per_click: int = 1
var units_per_second: float = 0
var luck: float = 0.0
var console: Label
var boost: int = 10000
var playtime: float = 0.0
var backgrounds: bool = false
var current_bg: int = 1

var achievements: Dictionary = {
	"DIAMONDS!": false,
	"Is it Wrong to Pick Up a Gem in a Dungeon?!": false,
	"Diamonds to You!": false,
	"Maverick Gamer": false,
	"God's Blessing on this Wonderful World!": false,
	"Leprechaun that Haunts the Rainbow...": false,
	"Getting an upgrade!": false,
	"Sluggin' out!": false,
	"Four Rhythms Across the Greyscale": false,
	"Sunshine Over the Rainbow...": false
}

#----------------
# AUTOSAVE TIMER

# Timer variable to accumulate delta time
var save_timer: float = 0.0
const SAVE_INTERVAL: float = 60.0  # Save every 60 seconds
#----------------

func _ready() -> void:
#----------------
	var loaded_data: Dictionary = Save.load_savegame()
	# Update variables with loaded data
	points = loaded_data.get("player_points", points)
	points_per_click = loaded_data.get("player_units_per_click", points_per_click)
	units_per_second = loaded_data.get("player_units_per_sec", units_per_second)
	luck = loaded_data.get("player_luck", luck)
	playtime = loaded_data.get("playtime", playtime)
	achievements = loaded_data.get("player_achievements", achievements)
	backgrounds = loaded_data.get("player_backgrounds", backgrounds)
	current_bg = loaded_data.get("player_current_bg", current_bg)
	#----------------
	await get_tree().process_frame
	console = get_node("/root/Clicker/VBoxContainer").get_child(3)

func reset_game_state() -> void:
#----------------
# GAME STATE RESET
	points = 0.0
	points_per_click = 1
	units_per_second = 0.0
	luck = 0.0
	playtime = 0.0
	current_bg = 1
	achievements = {
		"DIAMONDS!": false,
		"Is it Wrong to Pick Up a Gem in a Dungeon?!": false,
		"Diamonds to You!": false,
		"Maverick Gamer": false,
		"God's Blessing on this Wonderful World!": false,
		"Leprechaun that Haunts the Rainbow...": false,
		"Getting an upgrade!": false,
		"Sluggin' out!": false,
		"Four Rhythms Across the Greyscale": false,
		"Sunshine Over the Rainbow...": false
		}
	backgrounds = false
#	console.text = "Game started!"  # Set initial text for the console
#----------------

func _process(_delta: float) -> void:
	playtime += _delta
	# Accumulate delta time
	save_timer += _delta

	# Check if the accumulated time exceeds the save interval
	if save_timer >= SAVE_INTERVAL:
		Save.write_savegame()  # Save the game state
		save_timer = 0.0  # Reset the timer
	#Save.write_savegame()
#----------------
# GAME QUIT LOGIC
	if Input.is_action_just_pressed("quit") && OS.is_debug_build():
		Save.write_savegame()
		await get_tree().process_frame
		get_tree().quit()
		printerr("You quit!")
#----------------
# GAME BOOST DEBUG TOOL LOGIC
	if Input.is_action_just_pressed("boost") && OS.is_debug_build():
		points = points + boost
		print("You boosted up to: " + str(round((points))))
		console.text = "Boosted up to: " + str(round((points)))
#----------------
# GAME RELOAD DEBUG TOOL LOGIC
	if Input.is_action_just_pressed("reload"):
		get_tree().reload_current_scene()
		printerr("You reloaded!")
#		console.text = "Reloaded!"
		Save.load_savegame()
#----------------
# RESTART LOGIC
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
		_ready()
		printerr("You restarted!")
		reset_game_state()
#		console.text = "Restarted!"
#----------------
### CLICK INPUT TO CONSOLE
	#if Input.is_action_just_pressed("click"):
		#console.text = "You clicked"
#----------------


#----------------
# ACHIEVEMENTS
func achievement() -> void:
	if PlayerVariables.points >= 10:
		if PlayerVariables.achievements["DIAMONDS!"] == false:
			PlayerVariables.achievements["DIAMONDS!"] = true
			console.text += "\nYou unlocked the [DIAMONDS!] achievement!"
			print("You unlocked the [DIAMONDS!] achievement!")
	if PlayerVariables.points >= 100:
		if PlayerVariables.achievements["Is it Wrong to Pick Up a Gem in a Dungeon?!"] == false:
			PlayerVariables.achievements["Is it Wrong to Pick Up a Gem in a Dungeon?!"] = true
			console.text += "\nYou unlocked the [Is it Wrong to Pick Up a Gem in a Dungeon?!] achievement!"
			print("You unlocked the [Is it Wrong to Pick Up a Gem in a Dungeon?!] achievement!")
	if PlayerVariables.luck >= 2:
		if PlayerVariables.achievements["Diamonds to You!"] == false:
			PlayerVariables.achievements["Diamonds to You!"] = true
			console.text += "\nYou unlocked the [Diamonds to You!] achievement!"
			print("You unlocked the [Diamonds to You!] achievement!")
	if PlayerVariables.points_per_click >= 2:
		if PlayerVariables.achievements["Getting an upgrade!"] == false:
			PlayerVariables.achievements["Getting an upgrade!"] = true
			console.text += "\nYou unlocked the [Getting an upgrade!] achievement!"
			print("You unlocked the [Getting an upgrade!] achievement!")
	if PlayerVariables.luck >= 5:
		if PlayerVariables.achievements["God's Blessing on this Wonderful World!"] == false:
			PlayerVariables.achievements["God's Blessing on this Wonderful World!"] = true
			console.text += "\nYou unlocked the [God's Blessing on this Wonderful World!] achievement!"
			print("You unlocked the [God's Blessing on this Wonderful World!] achievement!")
	if PlayerVariables.luck >= 10:
		if PlayerVariables.achievements["Leprechaun that Haunts the Rainbow..."] == false:
			PlayerVariables.achievements["Leprechaun that Haunts the Rainbow..."] = true
			console.text += "\nYou unlocked the [Leprechaun that Haunts the Rainbow...] achievement!"
			print("You unlocked the [Leprechaun that Haunts the Rainbow...] achievement!")
	if PlayerVariables.playtime >= 3600.0:
		if PlayerVariables.achievements["Sluggin' out!"] == false:
			PlayerVariables.achievements["Sluggin' out!"] = true
			console.text += "\nYou unlocked the [Sluggin' out!!] achievement!"
			print("You unlocked the [Sluggin' out!!] achievement!")
	if PlayerVariables.backgrounds == true:
		if PlayerVariables.achievements["Four Rhythms Across the Greyscale"] == false:
			PlayerVariables.achievements["Four Rhythms Across the Greyscale"] = true
			console.text += "\nYou unlocked the [Four Rhythms Across the Greyscale] achievement!"
			print("You unlocked the [Four Rhythms Across the Greyscale] achievement!")
	# Check for 100% completion achievement
	var unlocked_count: int = 0
	for key: String in achievements.keys():
		if achievements[key]:
			unlocked_count += 1
	# Check if all but one achievements are unlocked
	if unlocked_count == achievements.size() - 1 and not achievements["Maverick Gamer"]:
		achievements["100% Completion"] = true
		console.text += "\nYou unlocked the [Maverick Gamer] achievement!"
		print("You unlocked the [Maverick Gamer] achievement!")
#----------------

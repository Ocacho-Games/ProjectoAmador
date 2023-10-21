extends Node

#==============================================================================
# VARIABLES
#==============================================================================

## Constant name of the saved game data, as a key
const SAVE_NAME = "Suap"

## Reference to the Google Play Game Services plugin
var GPGS

## Reference to the data to save for the user, so the user only have to care about modifying the data
var data_to_save : SSaveData = SSaveData.new()

#==============================================================================
# GODOT FUNCTIONS
#==============================================================================

## Overridden ready function
##
func _ready():
	if Engine.has_singleton("GodotPlayGamesServices"):
		GPGS = Engine.get_singleton("GodotPlayGamesServices")
		
		# First true means pull PlayerID, second one the email, third one the profile data
		GPGS.initWithSavedGames(true, SAVE_NAME, true, true, "")
		
		_connect_signals()
		GPGS.signIn()

#==============================================================================
# PUBLIC FUNCTIONS
#==============================================================================

## Save the game given the reference to the data to store on the cloud. 
## NOTE: Make sure to call the init function before calling this method 
##
func save_game() -> void:
	assert(GPGS, "Trying to call some GPS functions without proper GPS initialization!")
	GPGS.saveSnapshot(SAVE_NAME, JSON.new().stringify(data_to_save.data), "")

## Load the game. This will call a signal that will pull the saved data from the cloud. 
## NOTE: Make sure to call the init function before calling this method 
##	
func load_game() -> void:
	assert(GPGS, "Trying to call some GPS functions without proper GPS initialization!")
	print("Load the fucking GAMEEEE")
	GPGS.loadSnapshot(SAVE_NAME)

#==============================================================================
# PRIVATE FUNCTIONS
#==============================================================================

## Connect all the signals from the GPGS plugin to our local functions
##
func _connect_signals() -> void:
	GPGS.connect("_on_sign_in_success", _on_sign_in_success)
	GPGS.connect("_on_sign_in_failed", _on_sign_in_failed)		
	GPGS.connect("_on_game_saved_success", _on_game_saved_success)
	GPGS.connect("_on_game_saved_failed", _on_game_saved_failed)
	GPGS.connect("_on_game_load_success", _on_game_load_success)
	GPGS.connect("_on_game_load_failed", _on_game_load_failed)
	GPGS.connect("_on_create_new_snapshot", _on_create_new_snapshot)

#==============================================================================
# SIGNAL FUNCTIONS
#==============================================================================

func _on_sign_in_success(user_information):
	print("Sign in success: " + user_information)
	load_game()	
	
func _on_sign_in_failed(error_code : int):
	print("Sign in fail: " + str(error_code))

func _on_game_saved_success():
	print("Game saved successfuly")	
	
func _on_game_saved_failed():
	print("Game saved failed")	
	
func _on_game_load_success(json_data):
	print("Game load successfuly: " + json_data)

	var parsed_data = JSON.parse_string(json_data)
	data_to_save.copy_data(parsed_data)

func _on_game_load_failed():
	print("Game load failed")		
	
func _on_create_new_snapshot(name : String):
	print("Game create new snapshot: " + name)		

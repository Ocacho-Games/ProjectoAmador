## This autoload is in charge of all the related to Google Play Services (GPS).
## Provides logic for showing leaderboards, save and load the game mainly.
## It also contains the data to save to the cloud with GPS.
##
extends Node

#==============================================================================
# VARIABLES
#==============================================================================

## Constant name of the saved game data, as a key
const SAVE_NAME = "Suap"

## Reference to the Google Play Game Services plugin
var GPGS

## Data to save for the user, so the user only have to care about modifying the data. We load/save it here
## NOTE: This dictionary has entries for the shake of testing in PC. This should be empty for the release of the game
#var data_to_save_dic = {}
var data_to_save_dic = {	
		"coins" : 550,
		"clicker_score" : 0,
		"stack_score": 0,
		# This should be the same name as the bob.tres key. NOTE: This will contain all the unlocked resources "keys" of the colection
		"bob" : ["click_2"],
		"current_bob_sprite" : "",
		"current_bob_sound" : "click_2",
	}

## Whether the load_game function has been called at least once
var is_game_loaded : bool = false

#==============================================================================
# GODOT FUNCTIONS
#==============================================================================

## Overridden ready function
##
func _ready():
	if OS.get_name() != "Android":
		is_game_loaded = true
		
	if Engine.has_singleton("GodotPlayGamesServices"):
		GPGS = Engine.get_singleton("GodotPlayGamesServices")
		
		# First true means pull PlayerID, second one the email, third one the profile data
		GPGS.initWithSavedGames(true, SAVE_NAME, true, true, "")
		
		_connect_signals()
		GPGS.signIn()

## Overridden notification function
## This should be use to save the game when exiting but it's not working on android
##		
func _notification(id): 
	if id == NOTIFICATION_WM_GO_BACK_REQUEST:
		print("Quiting")

#==============================================================================
# PUBLIC FUNCTIONS
#==============================================================================

## Show the leaderboard of an specific minigame
## [minigame]: Reference to the minigame in order to get the ID of the leaderboard
##
func show_leaderboard(minigame : Minigame) -> void:
	if OS.get_name() == "Android":
		_check_gpgs()
		assert(minigame, "Invalid minigame in order to show the its leaderboard!")
		GPGS.showLeaderBoard(minigame.gps_leader_board_id)

## Show all the leaderboards of this game
##	
func show_all_leaderboards() -> void:
	if OS.get_name() == "Android":
		_check_gpgs()
		GPGS.showAllLeaderBoards()
	
## Submit a score to the leaderboard of an specific minigame
## [minigame]: Reference to the minigame in order to get the ID of the leaderboard
## [score]: Score to submit
##
func submit_leaderboard_score(minigame : Minigame, score) -> void:
	if OS.get_name() == "Android":
		_check_gpgs()
		GPGS.submitLeaderBoardScore(minigame.gps_leader_board_id, score)

## Save the game given the reference to the data to store on the cloud. 
## NOTE: Make sure to call the init function before calling this method 
##
func save_game() -> void:
	if OS.get_name() == "Android":
		_check_gpgs()
		GPGS.saveSnapshot(SAVE_NAME, JSON.stringify(data_to_save_dic), "")

## Load the game. This will call a signal that will pull the saved data from the cloud. 
## NOTE: Make sure to call the init function before calling this method 
##	
func load_game() -> void:
	if OS.get_name() == "Android":
		_check_gpgs()
		GPGS.loadSnapshot(SAVE_NAME)
		
## Get the value of the saved data dictionary given the key if valid if not, return return_thing
## [key]: Key of the data_to_save_dic 
## [return_thing]: In case the key doesn't exist, return this variadic, can be anything
##
func get_saved_data(key : String, return_thing = 0):
	if data_to_save_dic.has(key):
		return data_to_save_dic[key]
		
	return return_thing
		
#==============================================================================
# PRIVATE FUNCTIONS
#==============================================================================

## Checks if the singleton reference is valid, if not raise an assert. Used in functions that use the singleton
##
func _check_gpgs() -> void:
	assert(GPGS, "Trying to call some GPS functions without proper GPS initialization!")	

## Connect all the signals from the GPGS plugin to our local functions
##
func _connect_signals() -> void:
	GPGS.connect("_on_sign_in_success", _on_sign_in_success)
	GPGS.connect("_on_sign_in_failed", _on_sign_in_failed)		
	GPGS.connect("_on_leaderboard_score_submitted", _on_leaderboard_score_submitted)
	#TODO [David]: This event names aren't right... bro son los del tuto		
	#GPGS.connect("_on_leaderboard_score_submitted_failed", _on_leaderboard_score_submitted_failed)	
	GPGS.connect("_on_game_saved_success", _on_game_saved_success)
	#TODO [David]: This event names aren't right... bro son los del tuto	
	#GPGS.connect("_on_game_saved_failed", _on_game_saved_failed)
	GPGS.connect("_on_game_load_success", _on_game_load_success)
	#TODO [David]: This event names aren't right... bro son los del tuto
	#GPGS.connect("_on_game_load_failed", _on_game_load_failed)
	GPGS.connect("_on_create_new_snapshot", _on_create_new_snapshot)

#==============================================================================
# SIGNAL FUNCTIONS
#==============================================================================

func _on_sign_in_success(user_information):
	print("Sign in success: " + user_information)
	print("Sign in success: loading game...")	
	load_game()	
	
func _on_sign_in_failed(error_code : int):
	print("Sign in fail: " + str(error_code))
	
func _on_leaderboard_score_submitted(id : String):
	print("Leaderboard score submitted successfuly: " + id)
	
func _on_leaderboard_score_submitted_failed(id : String):
	print("Leaderboard score submitted failed: " + id)

func _on_game_saved_success():
	print("Game saved successfuly")	
	print(data_to_save_dic)
	
func _on_game_saved_failed():
	print("Game saved failed")	

## Updates the referenced game data once the game has been successfuly loaded.
##	
func _on_game_load_success(json_data):
	print("Game load successfuly: " + json_data)
	is_game_loaded = true

	data_to_save_dic = JSON.parse_string(json_data)

func _on_game_load_failed():
	print("Game load failed")		
	
func _on_create_new_snapshot(snapshot_name : String):
	print("Game create new snapshot: " + snapshot_name)		

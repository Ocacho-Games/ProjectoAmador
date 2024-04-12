## This autoload is in charge of all the related to Google Play Services (GPS).
## Provides logic for showing leaderboards, save and load the game mainly.
## It also contains the data to save to the cloud with GPS and in-app purchases.
##
extends Node

#==============================================================================
# SIGNALS
#==============================================================================
## Will be called once we have internet connection and gps has been initialized
signal on_gps_initialized

#==============================================================================
# VARIABLES
#==============================================================================

## Constant name of the saved game data, as a key
const SAVE_NAME = "Suap"

## Reference to the Google Play Game Services plugin
var GPGS

## Reference to the Google Play Billing plugin
var GPB

## Data to save for the user, so the user only have to care about modifying the data. We load/save it here
## NOTE: This dictionary has entries for the shake of testing in PC. This should be empty for the release of the game
#var data_to_save_dic = {}
var data_to_save_dic = {	
		"coins" : 550,
		"clicker_score" : 0,
		"stack_score": 0,
		# This should be the same name as the bob.tres key. NOTE: This will contain all the unlocked resources "keys" of the colection
		"bob" : ["fancy"],
		"current_bob_sprite" : "fancy",
	}

## Whether the load_game function has been called at least once
var is_game_loaded : bool = false
## Whether the _init_gps function has been called at least once successfully
var is_gps_initialized : bool = false

#==============================================================================
# GODOT FUNCTIONS
#==============================================================================

## Overridden ready function
##
func _ready():
	# Debug purpouses
	if OS.get_name() != "Android":
		is_game_loaded = true
		on_gps_initialized.emit()
	
	SNetwork.on_connection_success.connect(_init_gps)
	#TODO: If internet wasnt working but now we have internet another pop up and stop the game

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
## [leaderboard_id]: ID of the leaderboard from google play
##
func show_leaderboard(leaderboard_id : String) -> void:
	if OS.get_name() == "Android":
		_check_gpgs()
		GPGS.showLeaderBoard(leaderboard_id)

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

func append_saved_data(collection_key : String, collectable_key : String):
	if(data_to_save_dic.has(collection_key)):
		data_to_save_dic[collection_key].append(collectable_key)
	else:
		data_to_save_dic[collection_key] = [collectable_key]

## Helper function for connecting GPS signals with some checks
##
func connect_signal(signal_name : String, callable : Callable) -> void:
	if OS.get_name() == "Android":
		_check_gpgs()
		# TODO: Asserts for custom android
		GPGS.connect(signal_name, callable)

## Helper function for adding coins to the saved data
##
func add_coins(coins_to_add : int) -> void:
	SGPS.data_to_save_dic['coins'] += coins_to_add
		
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
	
## Init all the systems related to GPS.
## This will be called only if we have internet connection
##
func _init_gps() -> void:
	if is_gps_initialized: return
	
	if Engine.has_singleton("GodotPlayGamesServices"):
		GPGS = Engine.get_singleton("GodotPlayGamesServices")
		
		# First true means pull PlayerID, second one the email, third one the profile data
		GPGS.initWithSavedGames(true, SAVE_NAME, true, true, "")
		is_gps_initialized = true
		
		_connect_signals()
		on_gps_initialized.emit()
		GPGS.signIn()
	
	if Engine.has_singleton("GodotGooglePlayBilling"):
		GPB = Engine.get_singleton("GodotGooglePlayBilling")

		# These are all signals supported by the API
		# You can drop some of these based on your needs
#		payment.billing_resume.connect(_on_billing_resume) # No params
		GPB.connected.connect(_on_connected) # No params
#		payment.disconnected.connect(_on_disconnected) # No params
#		payment.connect_error.connect(_on_connect_error) # Response ID (int), Debug message (string)
#		payment.price_change_acknowledged.connect(_on_price_acknowledged) # Response ID (int)
#		payment.purchases_updated.connect(_on_purchases_updated) # Purchases (Dictionary[])
#		payment.purchase_error.connect(_on_purchase_error) # Response ID (int), Debug message (string)
#		payment.product_details_query_completed.connect(_on_product_details_query_completed) # Products (Dictionary[])
#		payment.product_details_query_error.connect(_on_product_details_query_error) # Response ID (int), Debug message (string), Queried SKUs (string[])
#		payment.purchase_acknowledged.connect(_on_purchase_acknowledged) # Purchase token (string)
#		payment.purchase_acknowledgement_error.connect(_on_purchase_acknowledgement_error) # Response ID (int), Debug message (string), Purchase token (string)
#		payment.purchase_consumed.connect(_on_purchase_consumed) # Purchase token (string)
#		payment.purchase_consumption_error.connect(_on_purchase_consumption_error) # Response ID (int), Debug message (string), Purchase token (string)
#		payment.query_purchases_response.connect(_on_query_purchases_response) # Purchases (Dictionary[])
		GPB.startConnection()
	else:
		print("Android IAP support is not enabled. Make sure you have enabled 'Gradle Build' and the GodotGooglePlayBilling plugin in your Android export settings! IAP will not work.")

#==============================================================================
# GPGS SIGNAL FUNCTIONS
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

#==============================================================================
# GPB SIGNAL FUNCTIONS
#==============================================================================

func _on_connected():
	GPB.querySkuDetails(["my_iap_item"], "inapp")

extends Node2D

#==============================================================================
# VARIABLES
#==============================================================================

## Whether the popup in case we are offline has been shown or not
var offline_pop_up_shown = false

## The collectable collections in case we want to add callbacks to objetive collectables
@export var collection_array : Array[SCollection]

#==============================================================================
# GODOT FUNCTIONS
#==============================================================================

func _ready():
	if OS.get_name() != "Android":
		SceneManager.change_scene("res://game/scenes/reel.tscn")
		SGame.load_all_collectable_callbacks(collection_array)		
	else:
		SNetwork.on_connection_failed.connect(_on_internet_connection_failed)
		SGPS.on_gps_initialized.connect(_on_gps_initialized)
	
#==============================================================================
# SIGNAL FUNCTIONS
#==============================================================================

## Called when we aren't connected to internet.
## In case it's the first time, we show the popup 
##
func _on_internet_connection_failed(_error, _msg): 
	if offline_pop_up_shown: return
	
	PopupLibrary.show_info_popup(self,
	 "You dont have internet connection mate. The game will start offline after you close this popup",
	 func(): SceneManager.change_scene("res://game/scenes/reel.tscn"))	

	offline_pop_up_shown = true	

## Called when gps is initialized. Changes to the reel scene when the game has been loaded
##		
func _on_gps_initialized() -> void:
	SGPS.connect_signal("_on_game_load_success", 
	func(_unused): 
		SceneManager.change_scene("res://game/scenes/reel.tscn")
		SGame.load_all_collectable_callbacks(collection_array))

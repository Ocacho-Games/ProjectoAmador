## Autoload in charge of managing the minigames array and global game data
## It also provides handy functionality for Minigame.gd instances
##
extends Node

#==============================================================================
# VARIABLES
#==============================================================================

## Preload reference to the array of minigames from the resource database 
var minigames_array = preload("res://game/resources/minigames_database.tres").minigames

## Whether the game is ready or not. This should be ONLY modified by start_game
var game_ready = false

## The last minigame index loaded in order to keep track of it
var last_minigame_index : int = 0

## Reference to the collections of collectables of this game
var collections : Array[SCollection] 

#==============================================================================
# GODOT FUNCTIONS
#==============================================================================

## Overriden ready function
##
func _ready():
	# TODO [David]: Should we popup info if we disconnect from internet? 
	# TODO [David]: We should develop an algorithm for this, for now it's disabled for the shake of testing
	#randomize()
	#minigames_array.shuffle()
	pass
	
#==============================================================================
# PUBLIC FUNCTIONS
#==============================================================================

## Set the game as ready and load the first minigame
##		
func start_game() -> PackedScene:
	game_ready = true
	return get_current_minigame_scene()

## Update the internal last_minigame_index in order to update the current scene index we are playing
## Ex: If we are playing the scene index 2, if we call this function tracked index will be 1.
##
func load_previous_miningame_index() -> void:
	last_minigame_index = _get_minigame_scene_index(last_minigame_index - 1)[1]
	
## Update the internal last_minigame_index in order to update the current scene index we are playing
## Ex: If we are playing the scene index 2, if we call this function tracked index will be 3.
##
func load_next_miningame_index() -> void:
	last_minigame_index = _get_minigame_scene_index(last_minigame_index + 1)[1]

## Get the current minigame PackedScene
## WARNING: This usually should be called after calling load_next/previous_miningame_index() function
##		
func get_current_minigame_scene() -> PackedScene:
	return _get_minigame_scene_index(last_minigame_index)[0]
	
## Get the previous minigame PackedScene
## WARNING: This usually should be called after calling load_next/previous_miningame_index() function
##		
func get_previous_minigame_scene() -> PackedScene:
	return _get_minigame_scene_index(last_minigame_index - 1)[0]

## Get the next minigame PackedScene
## WARNING: This usually should be called after calling load_next/previous_miningame_index() function
##	
func get_next_minigame_scene() -> PackedScene:
	return _get_minigame_scene_index(last_minigame_index + 1)[0]

## Look and return the name of the runtime scene of the minigame_node based on the scene path 
## [minigame_node] : Node that contains the Minigame.gd script.
##
func get_minigame_name(minigame_node : Minigame) -> String:
	for minigame in minigames_array:
		if minigame_node.scene_file_path == minigame.scene.resource_path:
			return minigame.game_key
	
	return ""
	
## Get the duration of a minigame based on the name of the given node
## [minigame_node] : Node that contains the Minigame.gd script. 
##
func get_minigame_duration(minigame_node : Minigame) -> float:
	for minigame in minigames_array:
		if minigame_node.key_name == minigame.game_key:
			return minigame.game_duration
			
	return -1
	
#################### COLLECTION FUNCTIONS ###########################

## Load the global and the specific game callbacks for the collectables that are objetives
##
func load_all_collectable_callbacks(in_collections : Array[SCollection]) -> void:
	collections = in_collections
	add_callable_to_objetive_collectable("asteroid", func(): return [false, 0.0], "pink")
	
	for minigame in minigames_array:
		minigame.scene.instantiate().load_collectable_callbacks(collections)

## Search for the collection based on the collection_key and then
## add the callback to the collectable that matches the collectable_key
##
func add_callable_to_objetive_collectable(collection_key : String, callable : Callable, collectable_key : String) -> void:
	for collection in collections:
		if collection.key == collection_key:
			collection.add_callable_to_objetive_collectable(callable, collectable_key)

#==============================================================================
# PRIVATE FUNCTIONS
#==============================================================================
	
## Get the scene related to the given minigame_index and the actual index of the scene retrieved
## [minigame_index] : The minigame scene index we want to load
## @return: A tuple containing the PackedScene and the index of that PackedScene for tracking it
##
func _get_minigame_scene_index(minigame_index : int):
	if game_ready == false: return
	
	assert(minigame_index >= -1, "Invalid index for changing the minigame")
	
	var loaded_minigame_index = minigame_index
	
	if minigame_index == -1:
		loaded_minigame_index = minigames_array.size() - 1
	elif minigame_index == minigames_array.size():
		loaded_minigame_index = 0
		
	return [minigames_array[loaded_minigame_index].scene, loaded_minigame_index]

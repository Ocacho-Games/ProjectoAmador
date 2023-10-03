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
var last_minigame_index : int = -1

#==============================================================================
# FUNCTIONS
#==============================================================================

## Overriden ready function
##
func _ready():
	MobileAds.initialize()
	#randomize()
	#minigames_array.shuffle()
	
	for minigame in minigames_array:
		print(minigame.scene.resource_path + " has " + str(minigame.game_duration))

## Set the game as ready and load the first minigame
##		
func start_game() -> void:
	game_ready = true
	next_minigame()

## Load the previous minigame
##		
func previous_minigame() -> void:
	_change_minigame(last_minigame_index -1)	

## Load the next minigame
##	
func next_minigame() -> void:
	_change_minigame(last_minigame_index + 1)
	
## Get the previous minigame PackedScene
##		
func get_previous_minigame_scene() -> PackedScene:
	return _get_minigame_scene_index(last_minigame_index -1)[0]	

## Get the next minigame PackedScene
##	
func get_next_minigame_scene() -> PackedScene:
	return _get_minigame_scene_index(last_minigame_index + 1)[0]
	
## Get the duration of a minigame based on the name of the given node
## WARNING: Make sure that your scene file and your root node of the scene have the same name.
## [minigame_node] : Node that contains the Minigame.gd script. 
##
func get_minigame_duration(minigame_node : Minigame) -> float:
	var split_name = str(minigame_node.get_path()).split("/", false, 10)
	var scene_name = split_name[split_name.size() - 1]
	
	for minigame in minigames_array:
		var split_name_resource = minigame.scene.resource_path.split("/", false, 10)
		var no_tscn 			= split_name_resource[split_name_resource.size() - 1].split(".", false, 10)
		var scene_resource_name = no_tscn[0]
		
		if scene_resource_name == scene_name:
			return minigame.game_duration
	
	return -1

## Load the scene of the minigame based on the given index performing some checks
## If we press "previous" from the first minigame we'll go to the last one
## If we press "next" from the last minigame we'll go to the first one
## [minigame_index] : The minigame index we want to load
##
func _change_minigame(minigame_index : int) -> void:			
	var values 	= _get_minigame_scene_index(minigame_index)
	var scene 	= values[0]
	
	last_minigame_index = values[1]
	
	SceneManager.change_scene(scene.resource_path, {
													"speed": 10,
													"pattern": "vertical",
													"on_tree_enter": func(scene): scene.get_child(0).on_tree_enter_from_autoload(),
													"on_ready": func(scene): scene.get_child(0).on_ready_from_autoload()
													})	
	
## TODO
## [minigame_index] : The minigame index we want to load
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

## Reel for playing our games. This is the most important class of our game.
## It's in charge of managing, displacing, loading, removing, lerping... the scene of our minigames
##
extends Node

#==============================================================================
# VARIABLES
#==============================================================================

## === REFERENCES VARIABLES ===
## Cached banner ad of the minigame in order to destroy it when exiting the mingame
var ad_view

## Cached current,previous and next instanciated PackedScenes in order to add/move/destroy them when changing among minigames
var current_minigame_node 	: Minigame = null
var previous_minigame_node 	: Minigame = null
var next_minigame_node		: Minigame = null

## === DISPLACEMENT VARIABLES ===
## Screen height of the screen. With capital letters cause it should be a constant
@onready var SCREEN_HEIGHT : float = ProjectSettings.get_setting("display/window/size/viewport_height")

## When we first begin dragging the y position of the input event in that moment
var drag_event_initial_y_position : float = 0

## Last drag direction while we are dragging
var last_drag_direction : SInputUtility.EGestureDirection

## === LERP VARIABLES ===
## Duration of the full lerp, this should be smaller when the total lerp is smaller
const lerp_duration : float = 0.2

## Whether we are learping to a new miningame or not
var is_lerping : bool = false

## Whether we should change the minigame while learping or we are learping back to the current minigame
var should_change_minigame_after_lerp = false

## Elapsed time since we have been lerping 
var lerp_elapsed_time : float = 0

## Initial value of the lerp when lerping minigames, it should be the current position of the actual minigame
var lerp_initial_value : float

## Target value of the lerp when lerping miningames, it should be the next or previous minigame position, depending on the dragging direction
var lerp_target_value : float

#==============================================================================
# GODOT FUNCTIONS
#==============================================================================

# Called when the node enters the scene tree for the first time.
func _ready():
	ad_view = AdsLibrary.load_show_banner()
	_init_game()

func _process(delta):
	_handle_dragging(delta)

## Overriden exit tree function
##			
func _exit_tree():
	if current_minigame_node:
		current_minigame_node.queue_free()
		current_minigame_node = null		
	
	if previous_minigame_node:
		previous_minigame_node.queue_free()
		previous_minigame_node = null		
	
	if next_minigame_node:
		next_minigame_node.queue_free()
		next_minigame_node = null
	
	if ad_view:
		ad_view.destroy()
		ad_view = null

#==============================================================================
# PRIVATE FUNCTIONS
#==============================================================================

## Initialize the game, instantiating and adding to the self node the first three minigames (current, previous and next)
## It also positions the three games to the right positions so we have the feeling of a reel when dragging.
## This should be called on the ready function of this script (reel.gd)
##
func _init_game() -> void:
	current_minigame_node = SGame.start_game().instantiate()
	add_child(current_minigame_node)
	
	_prepare_game()

## This function is in charge of reordering, adding and removing the necessary scenes in order to play a new game, next or previous.
## [specific_game]: Game reference we want to init, should be previous or next
## Ex: we are dragging from game 2 to game 3 -> We will remove the game 3 from the game 2 hierarchy since we need to add the game 3 to the reel node
## Then we add the game 3 to the reel node and we pretty much repeat the same process as _init_game(), previously loading the next or previous minigame index, depending on the given parameter
## [David]: I highly recommend putting a breakpoint on the top of the function an go step by step in order to see the process with the Remote option, so you can see the changes on runtime
##	
func _init_specific_game(specific_game : Minigame) -> void:
	current_minigame_node.remove_child(specific_game)
	remove_child(current_minigame_node)	
	
	specific_game.position.y = 0
	add_child(specific_game)
	current_minigame_node = specific_game	
	
	if specific_game == previous_minigame_node: SGame.load_previous_miningame_index()
	else: SGame.load_next_miningame_index()
	
	_prepare_game()

## This function is in charge of adding the previous and next minigames to the current one + setting the position of them.
## It also prepare the functionality for when the minigame should end related to the time bar based on the connected signal
##
func _prepare_game() -> void:
	previous_minigame_node  = SGame.get_previous_minigame_scene().instantiate()
	next_minigame_node		= SGame.get_next_minigame_scene().instantiate()
	
	current_minigame_node.add_child(previous_minigame_node)
	current_minigame_node.add_child(next_minigame_node)
	
	previous_minigame_node.position.y = -SCREEN_HEIGHT
	next_minigame_node.position.y = SCREEN_HEIGHT
	
	GameUtilityLibrary.resume_scene(current_minigame_node, [previous_minigame_node.get_path(), next_minigame_node.get_path()])	
	GameUtilityLibrary.pause_scene(previous_minigame_node)
	GameUtilityLibrary.pause_scene(next_minigame_node)
	
	current_minigame_node.connect("on_should_change_to_next_minigame", func():
		drag_event_initial_y_position = 0		
		is_lerping = true
		should_change_minigame_after_lerp = true
		lerp_initial_value = current_minigame_node.position.y
		last_drag_direction = SInputUtility.EGestureDirection.DOWN
		lerp_target_value = -SCREEN_HEIGHT)

## Called on _process, this function handles all the logic related to minigames scene interpolation or dragging displacement
## [delta]: Frame delta time coming from the _process function
##	
func _handle_dragging(delta) -> void:
	if !current_minigame_node.can_drag_from_reel(): return
	
	if is_lerping:
		_handle_reel_interpolation(delta)
		return
	
	var result_drag 	= SInputUtility.get_dragging_direction_vertical()
	var is_dragging 	= result_drag[0]
	last_drag_direction = result_drag[1] if is_dragging else last_drag_direction
	
	if !is_dragging:
		if SInputUtility.is_dragging.has_changed(false):
			if SInputUtility.is_swiping : _handle_swipe()
			else: _handle_dragging_just_false()
		return
		
	if SInputUtility.is_dragging.has_changed(true):
		GameUtilityLibrary.pause_scene(current_minigame_node, [previous_minigame_node.get_path(), next_minigame_node.get_path()])
	
	_handle_dragging_displacement()

## Called when we are actually dragging.
## This function is in charge of displacing the minigames in order to provoke a feeling of a reel
##
func _handle_dragging_displacement() -> void:
	if SInputUtility.is_dragging.has_changed(true):
		drag_event_initial_y_position = SInputUtility.cached_drag_event.position.y
		
	DebugDraw2D.set_text("Dragging direction", str(SInputUtility.EGestureDirection.keys()[last_drag_direction]))	
	current_minigame_node.position.y = SInputUtility.cached_drag_event.position.y - drag_event_initial_y_position

## Called when we are swiping. Swiping will allow an instant change to the next/previous minigame
##
func _handle_swipe() -> void:
	is_lerping = true
	lerp_initial_value = current_minigame_node.position.y
	should_change_minigame_after_lerp = true
	lerp_target_value = SCREEN_HEIGHT if last_drag_direction == SInputUtility.EGestureDirection.UP else -SCREEN_HEIGHT

## Called the first time the dragging becomes false after being true.
## This function is in charge of setting if we have to set the proper values for changing to the next or previous miningame based on the height threshold.
## [David]: Right now, the threshold is set to the middle of the screen, if the drag is bigger than half screen, we will change
##
func _handle_dragging_just_false() -> void:
	is_lerping = true
	lerp_initial_value = current_minigame_node.position.y
	GameUtilityLibrary.resume_scene(current_minigame_node,[previous_minigame_node.get_path(), next_minigame_node.get_path()])
	
	var threshold_passed
	if last_drag_direction == SInputUtility.EGestureDirection.UP:
		threshold_passed = current_minigame_node.position.y > SCREEN_HEIGHT / 3
		should_change_minigame_after_lerp = true if threshold_passed else false
		lerp_target_value = SCREEN_HEIGHT if threshold_passed else 0.0
	else:
		threshold_passed = current_minigame_node.position.y > -(SCREEN_HEIGHT / 3)
		should_change_minigame_after_lerp = false if threshold_passed else true
		lerp_target_value = 0.0 if threshold_passed else -SCREEN_HEIGHT
		
## Called when we should interpolate to the same or another minigame
## This functions displace the current minigame position in y in order to reach the target in the given lerp_duration.
## NOTE: The lerp_duration will vary depending on the distance of the initial and the target. Longer distance longer time
##	
func _handle_reel_interpolation(delta) -> void:
	lerp_elapsed_time += delta
	var delta_lerp_distance 	= abs(abs(lerp_initial_value) - abs(lerp_target_value))
	var lerp_alpha_multiplier 	= delta_lerp_distance / SCREEN_HEIGHT
	var alpha = min(1, lerp_elapsed_time / (lerp_duration * lerp_alpha_multiplier))
	current_minigame_node.position.y = lerp(lerp_initial_value, lerp_target_value, alpha)

	if alpha >= 1:
		if should_change_minigame_after_lerp: 
			if last_drag_direction == SInputUtility.EGestureDirection.UP: _init_specific_game(previous_minigame_node)
			else: _init_specific_game(next_minigame_node)

		is_lerping = false
		lerp_elapsed_time = 0

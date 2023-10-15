extends Node

#@onready var minigame : Minigame = self.get_child(0)

var first_drag_y_value : float = 0
var current_scene_offset: float = 0

var last_drag_direction : SInputUtility.EGestureDirection
var last_swipe_direction : SInputUtility.EGestureDirection

var is_lerping : bool = false
var should_change_minigame = false
const lerp_duration : float = 0.1
var target_value : float
var elapsed_time : float = 0
var initial_minigame_position : float

## Cached banner ad of the minigame in order to destroy it when exiting the mingame
var ad_view

## Cached previos/next instanciated PackedScenes in order to destroy them when exiting the tree
var current_scene_node 	: Minigame = null
var previous_scene_node : Minigame = null
var next_scene_node		: Minigame = null


# Called when the node enters the scene tree for the first time.
func _ready():
	ad_view = AdsLibrary.load_show_banner()
	_init_game()

func _process(delta):
#	if minigame.is_active == false: return
#
#	#TODO: All this to a private method =================================================
	var result = SInputUtility.get_dragging_direction_vertical()

	if result[0] and !is_lerping: last_drag_direction = result[1]

	if SInputUtility.is_dragging.has_changed(true) and !is_lerping:
		first_drag_y_value = SInputUtility.cached_drag_event.position.y
		current_scene_offset = current_scene_node.position.y

	if SInputUtility.is_dragging.has_changed(false) and !is_lerping:
		var screen_height = ProjectSettings.get_setting("display/window/size/viewport_height")		
		if last_drag_direction == SInputUtility.EGestureDirection.UP:
			if current_scene_node.position.y > screen_height / 2:
				is_lerping = true
				should_change_minigame = true
				target_value = screen_height
				initial_minigame_position = current_scene_node.position.y
			else:
				is_lerping = true
				should_change_minigame = false				
				target_value = 0
				initial_minigame_position = current_scene_node.position.y				
		else:
			if current_scene_node.position.y > -(screen_height / 2):
				is_lerping = true
				should_change_minigame = false				
				target_value = 0
				initial_minigame_position = current_scene_node.position.y				
			else: 
				is_lerping = true
				should_change_minigame = true				
				target_value = -screen_height
				initial_minigame_position = current_scene_node.position.y	

	if result[0] and !is_lerping:
		DebugDraw2D.set_text("Dragging direction", str(SInputUtility.EGestureDirection.keys()[result[1]]))	
		current_scene_node.position.y = SInputUtility.cached_drag_event.position.y - first_drag_y_value + current_scene_offset

	if is_lerping:		
		elapsed_time += delta
		var t = min(1, elapsed_time / lerp_duration)
		current_scene_node.position.y = lerp(initial_minigame_position, target_value, t)

		if t >= 1:
			if should_change_minigame: 
				if last_drag_direction == SInputUtility.EGestureDirection.UP: _init_specific_game(previous_scene_node)
				else: _init_specific_game(next_scene_node)

			is_lerping = false
			elapsed_time = 0
	#TODO: All this to a private method ==============================================
	
## Overriden exit tree function
##			
func _exit_tree():
	if current_scene_node:
		current_scene_node.queue_free()
		current_scene_node = null		
	
	if previous_scene_node:
		previous_scene_node.queue_free()
		previous_scene_node = null		
	
	if next_scene_node:
		next_scene_node.queue_free()
		next_scene_node = null
	
	if ad_view:
		ad_view.destroy()
		ad_view = null

## TODO
##
func _init_game():
	current_scene_node = SGame.start_game().instantiate()
	add_child(current_scene_node)
	
	previous_scene_node = SGame.get_previous_minigame_scene().instantiate()
	next_scene_node		= SGame.get_next_minigame_scene().instantiate()
	
	current_scene_node.add_child(previous_scene_node)
	current_scene_node.add_child(next_scene_node)
	
	var screen_height = ProjectSettings.get_setting("display/window/size/viewport_height")
	previous_scene_node.position.y = -screen_height
	next_scene_node.position.y = screen_height

## TODO
##	
func _init_specific_game(specific_game : Minigame):
	current_scene_node.remove_child(specific_game)
	specific_game.position.y = 0
	add_child(specific_game)
	remove_child(current_scene_node)
	
	current_scene_node = specific_game
	
	if specific_game == previous_scene_node: SGame.get_previous_minigame_scene(true)
	else: SGame.get_next_minigame_scene(true)
	
	previous_scene_node = SGame.get_previous_minigame_scene().instantiate()
	next_scene_node		= SGame.get_next_minigame_scene().instantiate()
	
	current_scene_node.add_child(previous_scene_node)
	current_scene_node.add_child(next_scene_node)
	
	var screen_height = ProjectSettings.get_setting("display/window/size/viewport_height")
	previous_scene_node.position.y = -screen_height
	next_scene_node.position.y = screen_height
	
	

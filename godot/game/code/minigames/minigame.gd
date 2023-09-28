@tool
## Base class 
## This is the base class for Minigames. Mingames should extends from this 
## It contains common logic such as 
## 		- The progression bar of the minigame.
##		- The logic for jumping into the next game if the progress bar is 100%
##		- The logic for swiping for next or previous minigame.
##
class_name Minigame extends Node2D

#==============================================================================
# VARIABLES
#==============================================================================

## Reference to the progress bar of the minigame. Each Minigame must have a progress bar
@onready var TimeBar : ProgressBar = $ProgressBar 

## Duration of this minigame. Dictated by the minigames database resource of the autoload
var minigame_duration = 0

## Current duration of this minigame. Used for changing scenes
var current_minigame_duration = 0

## TODO: This shouldn't be necessary. See to change this by on load after the transition
var is_active = false

## Cached banner ad of the minigame in order to destroy it when exiting the mingame
var ad_view

## Cached previos/next instanciated PackedScenes in order to destroy them when exiting the tree
var previous_scene_node : Minigame = null
var next_scene_node		: Minigame = null

var is_dragging : STrackVariable

var is_dragging_bool = false
var cached_event_drag : InputEvent
var is_touching_bool = false

#==============================================================================
# FUNCTIONS
#==============================================================================

## Overriden ready function
##
func _ready():	
	ad_view = AdsLibrary.load_show_banner()
	
	TimeBar.fill_mode = ProgressBar.FILL_BEGIN_TO_END 		
	minigame_duration = SGame.get_minigame_duration(self)
	
	if minigame_duration == -1:
		TimeBar.visible = false
	
	is_dragging = STrackVariable.new(false)

## Overriden input function
##
func _input(event):
	if is_active == false: return
	is_dragging_bool = false	
	
#	if event is InputEventSingleScreenSwipe:
#		if event.position.y < event.relative.y:
#			SGame.previous_minigame()
#		else:
#			SGame.next_minigame()
	
	if event is InputEventSingleScreenDrag:
		cached_event_drag = event
		is_dragging.set_value(true) 
		is_dragging_bool = true
		
		var screen_height = ProjectSettings.get_setting("display/window/size/viewport_height")
		#print(-(screen_height/2))
		var is_dragging_down = event.relative.y > 0
		var is_dragging_up = !is_dragging_down
		
		#print(next_scene_node.position.y)
		
		var can_drag_down	: bool = previous_scene_node.position.y < -(screen_height/2)
		var can_drag_up		: bool = next_scene_node.position.y > (screen_height/2)
		
		if (can_drag_down and is_dragging_down) or (can_drag_up and is_dragging_up): 
			self.position.y += event.relative.y
			previous_scene_node.position.y += event.relative.y
			next_scene_node.position.y += event.relative.y
		elif is_dragging_down: # TODO
			self.position.y = screen_height / 2		
			previous_scene_node.position.y = -(screen_height/2)
			next_scene_node.position.y = event.relative.y
		elif is_dragging_up: # TODO
			self.position.y = screen_height / 2		
			previous_scene_node.position.y = -(screen_height/2)
			next_scene_node.position.y = event.relative.y		
	elif event is InputEventSingleScreenTouch:
		is_touching_bool = event.pressed

## Overriden process function
##
func _process(delta):
	if is_active == false: return
	
	is_dragging_bool = cached_event_drag != null
	print("Is dragging bool: " + str(is_dragging_bool))
	
	if !is_touching_bool: 
		cached_event_drag = null
		
	# TODO. Make a component to have some fucntions like tuple<bool,float> ShouldLerpToPreviousMinigame() or something and then make the interpolation here
	
	if TimeBar.visible:
		current_minigame_duration += delta
		TimeBar.value = (current_minigame_duration * 100) / minigame_duration
		
		if current_minigame_duration >= minigame_duration:
			SGame.next_minigame()
			is_active = false

## Overriden exit tree function
##			
func _exit_tree():
	is_active = false
	
	if previous_scene_node:
		previous_scene_node.queue_free()
		previous_scene_node = null		
	
	if next_scene_node:
		next_scene_node.queue_free()
		next_scene_node = null
	
	if ad_view:
		ad_view.destroy()
		ad_view = null
		
#==============================================================================
# SCENE MANAGER FUNCTIONS
#==============================================================================
		
## Called from the game autload when this minigame is the selected one to play
##
func on_tree_enter_from_autoload() -> void:
	previous_scene_node = SGame.get_previous_minigame_scene().instantiate()
	next_scene_node		= SGame.get_next_minigame_scene().instantiate()
	
	add_child(previous_scene_node)
	add_child(next_scene_node)
	
	var screen_height = ProjectSettings.get_setting("display/window/size/viewport_height")
	previous_scene_node.position.y = -screen_height
	next_scene_node.position.y = screen_height
	
## Called from the game autload when this minigame is the selected one to play
##
func on_ready_from_autoload() -> void:
	is_active = true


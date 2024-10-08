## Autoload in charge of providing additional input functionality for our game based on the touch_input_manager addon
## This provides an easy access way to check if we are dragging, swipping or simple touching the screen without caring about the _input function from godot.
##
extends Node

#==============================================================================
# TYPES
#==============================================================================

## Possible directions of the committed gesture
enum EGestureDirection {UP, DOWN, LEFT, RIGHT}

#==============================================================================
# TYPES
#==============================================================================

## Minimum displacement threshold for the relative vector of the drag input event.
## If the drag is too little, so the relative is less than this, we won't treat the drag as a valid drag
const RELATIVE_MINIMUM = 2.0

## Minimum displacement threshold for the relative vector of the drag input event in order to trigger a swipe.
## This means, if the user drag to quick we will consider the drag a swipe
const SWIPING_RELATIVE_MINIMUM = 10.0

## Whether we are touching the screen or not
var is_touching = false

## Boolean track variable in order to know if we are dragging or not. 
## "is_dragging" will only be valid while we are touching the screen
var is_dragging : STrackVariable

## Boolean track variable in order to know if we are tapping or not. 
var is_tapping : STrackVariable

var tapping_position = Vector2(0.0,0.0)

## Whether we are swiping or not. This will only be true when we are not longer dragging, obviously.
var is_swiping : bool = false

## If this is bigger than SWIPING_RELATIVE_MINIMUM, we are swiping 
var max_y_dragging_relative = 0.0

## Cached last drag event emitted by the input function in order to 
var cached_drag_event : InputEventSingleScreenDrag

#==============================================================================
# GODOT FUNCTIONS
#==============================================================================

## Overriden ready function
##
func _ready():
	is_dragging = STrackVariable.new(false)
	is_tapping	= STrackVariable.new(false)	

## Overriden input function
##
func _input(event):
	is_tapping.set_value(false)	  		
	
	if event is InputEventSingleScreenDrag:
		cached_drag_event = event
		if abs(event.relative.y) > max_y_dragging_relative: 
			max_y_dragging_relative = abs(event.relative.y)
	elif event is InputEventSingleScreenTouch:
		is_touching = event.pressed
	elif event is InputEventSingleScreenTap:
		is_tapping.set_value(true)
		tapping_position = event.position

## Overriden process function
##
func _process(_delta):
	is_swiping = false
	
	if !is_touching:
		cached_drag_event = null
	
	is_dragging.set_value(cached_drag_event != null)

#==============================================================================
# PUBLIC FUNCTIONS
#==============================================================================

## Get as a tuple, if we are dragging and the direction of that dragging, horizontally
##
func get_dragging_direction_horizontal():
	var result = _get_gesture_direction(is_dragging, cached_drag_event)
	if !result[0]: return result
	
	if result[1] == EGestureDirection.LEFT or result[1] == EGestureDirection.RIGHT:
		return result
		
	return [false, EGestureDirection.UP]	

## Get as a tuple, if we are dragging and the direction of that dragging, vertically
##
func get_dragging_direction_vertical():
	var result = _get_gesture_direction(is_dragging, cached_drag_event)
	if !result[0]:
		is_swiping = max_y_dragging_relative > SWIPING_RELATIVE_MINIMUM
		max_y_dragging_relative = 0
		return result
	
	if result[1] == EGestureDirection.UP or result[1] == EGestureDirection.DOWN:
		return result
		
	return [false, EGestureDirection.UP]

#==============================================================================
# PRIVATE FUNCTIONS
#==============================================================================

## Given a gesture to check and the input event related to it, get if we are performing the given gesture and its direction
## [track_variable]: Gesture track variable (usually a boolean) that we want to check if we are performing
## [event]: Cached input event of the gesture we are checking in order to check the direction of the gesture
## @return: A tuple containing if we are performing the gesture passed as a track_variable and the direction of the gesture
##
func _get_gesture_direction(track_variable : STrackVariable, event : InputEvent):
	if !track_variable.value or !event: return [false, EGestureDirection.UP]
	
	var relative_x = event.relative.x
	var relative_y = event.relative.y
	
	if abs(relative_x) < RELATIVE_MINIMUM and abs(relative_y) < RELATIVE_MINIMUM: return [false, EGestureDirection.UP]
	
	if abs(relative_x) > abs(relative_y):
		if relative_x > 0: return [true, EGestureDirection.LEFT]
		else: return [true, EGestureDirection.RIGHT]
	else:
		if relative_y > 0: return [true, EGestureDirection.UP]
		else: return [true, EGestureDirection.DOWN]

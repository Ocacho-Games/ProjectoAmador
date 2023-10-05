extends Node

var is_dragging : STrackVariable
var is_swiping 	: STrackVariable
var is_touching = false
var cached_drag_event : InputEventSingleScreenDrag
var cached_swipe_event : InputEventSingleScreenSwipe

enum EDragDirection {UP, DOWN, LEFT, RIGHT}

func _ready():
	is_dragging = STrackVariable.new(false)
	is_swiping 	= STrackVariable.new(false)	

func _input(event):
	if event is InputEventSingleScreenDrag:
		cached_drag_event = event
	elif event is InputEventSingleScreenSwipe:
		cached_swipe_event = event
	elif event is InputEventSingleScreenTouch:
		is_touching = event.pressed

func _process(delta):
	is_dragging.set_value(cached_drag_event != null)  
	is_swiping.set_value(cached_swipe_event != null)  
	
	if !is_touching: 
		cached_drag_event 	= null
		cached_swipe_event 	= null

func _get_gesture_direction(track_variable : STrackVariable, event : InputEvent):
	if !is_dragging.value or !event: return [false, EDragDirection.UP]
	
	var relative_x = event.relative.x
	var relative_y = event.relative.y
	
	if abs(relative_x) < 2 and abs(relative_y) < 2: return [false, EDragDirection.UP]
	
	if abs(relative_x) > abs(relative_y):
		if relative_x > 0: return [true, EDragDirection.LEFT]
		else: return [true, EDragDirection.RIGHT]
	else:
		if relative_y > 0: return [true, EDragDirection.UP]
		else: return [true, EDragDirection.DOWN]

func get_dragging_direction_horizontal():
	var result = _get_gesture_direction(is_dragging, cached_drag_event)
	if !result[0]: return result
	
	if result[1] == EDragDirection.LEFT or result[1] == EDragDirection.RIGHT:
		return result
		
	return [false, EDragDirection.UP]	

func get_dragging_direction_vertical():
	var result = _get_gesture_direction(is_dragging, cached_drag_event)
	if !result[0]: return result
	
	if result[1] == EDragDirection.UP or result[1] == EDragDirection.DOWN:
		return result
		
	return [false, EDragDirection.UP]
	
func get_swiping_direction_horizontal():
	var result = _get_gesture_direction(is_swiping, cached_swipe_event)
	if !result[0]: return result
	
	if result[1] == EDragDirection.LEFT or result[1] == EDragDirection.RIGHT:
		return result
		
	return [false, EDragDirection.UP]	

func get_swiping_direction_vertical():
	var result = _get_gesture_direction(is_swiping, cached_swipe_event)
	if !result[0]: return result
	
	if result[1] == EDragDirection.UP or result[1] == EDragDirection.DOWN:
		return result
		
	return [false, EDragDirection.UP]

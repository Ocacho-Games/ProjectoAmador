extends Node

var is_dragging : STrackVariable
var is_touching = false
var cached_drag_event : InputEventSingleScreenDrag

enum EDragDirection {UP, DOWN, LEFT, RIGHT}

func _ready():
	is_dragging = STrackVariable.new(false)

func _input(event):
	if event is InputEventSingleScreenDrag:
		cached_drag_event = event
	elif event is InputEventSingleScreenTouch:
		is_touching = event.pressed

func _process(delta):
	is_dragging.set_value(cached_drag_event != null)  
	
	if !is_touching: 
		cached_drag_event = null

func get_dragging_direction():
	if !is_dragging or !cached_drag_event: return [false, EDragDirection.UP]
	
	var relative_x = cached_drag_event.relative.x
	var relative_y = cached_drag_event.relative.y
	
	if abs(relative_x) > abs(relative_y):
		if relative_x > 0: return [true, EDragDirection.LEFT]
		else: return [true, EDragDirection.RIGHT]
	else:
		if relative_y > 0: return [true, EDragDirection.UP]
		else: return [true, EDragDirection.DOWN]

func get_dragging_direction_horizontal():
	var result = get_dragging_direction()
	if !result[0]: return result
	
	if result[1] == EDragDirection.LEFT or result[1] == EDragDirection.RIGHT:
		return result
		
	return [false, EDragDirection.UP]	

func get_dragging_direction_vertical():
	var result = get_dragging_direction()
	if !result[0]: return result
	
	if result[1] == EDragDirection.UP or result[1] == EDragDirection.DOWN:
		return result
		
	return [false, EDragDirection.UP]

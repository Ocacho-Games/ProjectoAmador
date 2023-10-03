extends Node

@onready var minigame : Minigame = self.get_child(0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var first_drag_y_value : float = 0
var current_scene_offset: float = 0
var last_drag_direction : SInputUtility.EDragDirection

var is_lerping : bool = false
var lerp_duration : float = 0.1
var target_value : float
var elapsed_time : float = 0
var initial_minigame_position : float

func _process(delta):
	if minigame.is_active == false: return
	
	#TODO: All this to a private method =================================================
	var result = SInputUtility.get_dragging_direction_vertical()
	
	if result[0]: last_drag_direction = result[1]
	
	if SInputUtility.is_dragging.has_changed(true):
		first_drag_y_value = SInputUtility.cached_drag_event.position.y
		current_scene_offset = minigame.position.y
		
	if SInputUtility.is_dragging.has_changed(false):
		print(last_drag_direction)
		var screen_height = ProjectSettings.get_setting("display/window/size/viewport_height")		
		if last_drag_direction == SInputUtility.EDragDirection.UP:
			if minigame.position.y > screen_height / 2:
				is_lerping = true
				target_value = screen_height
				initial_minigame_position = minigame.position.y
			else:
				is_lerping = true
				target_value = 0
				initial_minigame_position = minigame.position.y				
		else:
			print(abs(minigame.position.y))
			if abs(minigame.position.y) < screen_height / 2:
				is_lerping = true
				target_value = 0
				initial_minigame_position = minigame.position.y				
			else: 
				is_lerping = true
				target_value = -screen_height
				initial_minigame_position = minigame.position.y				
			
	if result[0]:
		DebugDraw2D.set_text("Dragging direction", str(SInputUtility.EDragDirection.keys()[result[1]]))	
	
		if abs(SInputUtility.cached_drag_event.relative.y) > 2:
			minigame.position.y = SInputUtility.cached_drag_event.position.y - first_drag_y_value + current_scene_offset
	
	if is_lerping:		
		elapsed_time += delta
		var t = min(1, elapsed_time / lerp_duration)
		minigame.position.y = lerp(initial_minigame_position, target_value, t)

		if t >= 1:
			is_lerping = false
			# Interpolation is complete
			elapsed_time = 0
			# You can perform actions here when the interpolation finishes
	#TODO: All this to a private method ==============================================

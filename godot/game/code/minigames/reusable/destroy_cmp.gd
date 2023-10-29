## Destroys a Node based on the DestroyAction
##
class_name DestroyCmp extends Node

# TODO [David]: Add animation or whatever that we can play

#==============================================================================
# TYPES
#==============================================================================

## Type of action that should happen in order to destroy the Node
enum EDestroyAction { SCREEN_BORDERS, SCREEN_BOTTOM, SCREEN_TOP, SCREEN_LEFT, SCREEN_RIGHT }

#==============================================================================
# VARIABLES
#==============================================================================

## Which type of action shoudl destroy the parent object. See EDestroyAction for more info
@export var destroy_action : EDestroyAction

#==============================================================================
# GODOT FUNCTIONS
#==============================================================================

# Called when the node enters the scene tree for the first time.
func _ready():
	set_name.call_deferred("DestroyCmp")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	_handle_screen_borders()
	
#==============================================================================
# PRIVATE FUNCTIOINS
#==============================================================================	
	
## Check if the sprite of the parent node is beyond the screen borders in order to destroy it
##	
func _handle_screen_borders() -> void:
	var sprite = get_parent().get_node("Sprite2D")
	assert(sprite, "The parent Node doesn't have a sprite as a child")
	
	var screen_height = ProjectSettings.get_setting("display/window/size/viewport_height")
	var screen_width = ProjectSettings.get_setting("display/window/size/viewport_width")
	
	var screen_bottom 	: bool = get_parent().position.y > screen_height
	var screen_top 		: bool = get_parent().position.y < 0
	var screen_left 	: bool = get_parent().position.x < 0
	var screen_right 	: bool = get_parent().position.x > screen_width
	
	if destroy_action == EDestroyAction.SCREEN_BOTTOM	: if screen_bottom: _destroy()
	if destroy_action == EDestroyAction.SCREEN_TOP		: if screen_bottom: _destroy()  
	if destroy_action == EDestroyAction.SCREEN_LEFT		: if screen_bottom: _destroy()  
	if destroy_action == EDestroyAction.SCREEN_RIGHT	: if screen_bottom: _destroy()  
	
	if destroy_action == EDestroyAction.SCREEN_BORDERS:
		if screen_bottom or screen_top or screen_left or screen_right: _destroy()
		
## Get the parent and destroy the whole node
##
func _destroy() -> void:
	get_parent().queue_free()

## Destroys a Node based on the DestroyAction
##
class_name DestroyCmp extends Node

# TODO [David]: Add animation or whatever that we can play

#==============================================================================
# TYPES
#==============================================================================

## Type of action that should happen in order to destroy the Node
enum EDestroyAction { SCREEN_BORDERS }

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
func _process(delta):
	_handle_screen_borders()
	
#==============================================================================
# PRIVATE FUNCTIOINS
#==============================================================================	
	
## Check if the sprite of the parent node is beyond the screen borders in order to destroy it
##	
func _handle_screen_borders() -> void:
	if destroy_action != EDestroyAction.SCREEN_BORDERS: return  
	
	var sprite = get_parent().get_node("Sprite2D")
	assert(sprite, "The parent Node doesn't have a sprite as a child")
	
	var screen_height = ProjectSettings.get_setting("display/window/size/viewport_height")
	var screen_width = ProjectSettings.get_setting("display/window/size/viewport_width")
	
	if get_parent().position.y > screen_height + sprite.texture.get_height() * 2	: _destroy()
	if get_parent().position.y < 0 - sprite.texture.get_height() * 2				: _destroy()
	if get_parent().position.x > screen_width + sprite.texture.get_width() * 2		: _destroy()
	if get_parent().position.x < 0 - sprite.texture.get_width() * 2					: _destroy()

## Get the parent and destroy the whole node
##
func _destroy() -> void:
	get_parent().queue_free()

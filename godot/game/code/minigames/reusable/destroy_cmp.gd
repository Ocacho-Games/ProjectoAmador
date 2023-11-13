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

## Half of the width of the parent object. The parent object should have a Sprite2D or a TextureRect in order to calculate the width 
@onready var half_object_width = GameUtilityLibrary.get_node_actual_width(get_parent()) / 2.0
## Half of the height of the parent object. The parent object should have a Sprite2D or a TextureRect in order to calculate the height 
@onready var half_object_height = GameUtilityLibrary.get_node_actual_height(get_parent()) / 2.0

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
	var position_parent = get_parent().position
	var rigidbody = GameUtilityLibrary.get_child_node_by_class(get_parent(), "RigidBody2D")
	if rigidbody:
		position_parent += rigidbody.position

	var screen_bottom 	: bool = position_parent.y + half_object_height > GameUtilityLibrary.SCREEN_HEIGHT
	var screen_top 		: bool = position_parent.y - half_object_height < 0
	var screen_left 	: bool = position_parent.x - half_object_width  < 0
	var screen_right 	: bool = position_parent.x + half_object_width  > GameUtilityLibrary.SCREEN_WIDTH

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

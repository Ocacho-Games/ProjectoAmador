## Support auto movement for your entities based on different movement and rotation patterns that you can tweak
## [David]: I don't know if this is supposed to be an sprite we can change it
##
class_name AutoMovementCmp extends Node

#==============================================================================
# TYPES
#==============================================================================

## Type of movement pattern the entity will follow
## FIXED_UNITS: This means the entity will move only for some fixed amount and then back, again and again. 
enum EMovementType 	{ NO_MOVEMENT, HORIZONTAL, VERTICAL, FWD, LEFT, BWD, RIGHT, DIAGONAL_LEFT, DIAGONAL_RIGHT, FWD_LEFT, FWD_RIGHT, BWD_LEFT, BWD_RIGHT, FIXED_UNITS }

## Type of change that will trigger a change in the movement.
## NOTE!: Only HORIZONTAL, VERTICAL, DIAGONAL_LEFT and DIAGONAL_RIGHT are elegible for changing. See _is_direction_changeable()
## SCREEN_WIDHT: If the entity reaches the maximum width we will change the direction
## SCREEN_HEIGHT: If the entity reaches the maximum height we will change the direction
## INPUT_TAP: If we perform an input tap we will change the direction
enum EChangeType 	{ NO_CHANGE, SCREEN_WIDHT, SCREEN_HEIGHT, INPUT_TAP }

## Type of rotation we want for our entity
## CONSTANT: We will apply a constant rotation every frame. Negative means CCW, positive CW
## ORIENTED_TO_MOVEMENT: The rotation will follow the movement of the entity
enum ERotationType  { NO_ROTATION, CONSTANT, ORIENTED_TO_MOVEMENT}

#==============================================================================
# VARIABLES
#==============================================================================

## [Normalized] Constant direction vectors
const DIRECTION_FWD			: Vector2 = Vector2 (0, -1)
const DIRECTION_RIGHT 		: Vector2 = Vector2 (1, 0) 
const DIRECTION_LEFT		: Vector2 = Vector2 (-1, 0)
const DIRECTION_BWD			: Vector2 = Vector2 (0, 1)
const DIRECTION_FWD_LEFT	: Vector2 = Vector2 (-0.7, -0.7)
const DIRECTION_FWD_RIGHT	: Vector2 = Vector2 (0.7, -0.7)
const DIRECTION_BWD_LEFT	: Vector2 = Vector2 (-0.7, 0.7)
const DIRECTION_BWD_RIGHT	: Vector2 = Vector2 (0.7, 0.7)

@export_group("Base")
## Whether this component is enabled or not. 
@export var enable 			: bool = false

@export_group("Movement")
## Pattern of movement we want to follow. See EMovementType for more info
@export var movement_type 	: EMovementType = EMovementType.HORIZONTAL
## Initial movement direction to follow. This should be something like LEFT, RIGHT or similar. Otherwise the cmp won't work as expected
@export var initial_direction : EMovementType = EMovementType.NO_MOVEMENT
## Change pattern we want to follow. See EChangeType for more info
@export var change_type 	: EChangeType = EChangeType.NO_CHANGE
## Entity's acceleration. NOT USED
@export var acceleration	: float = 0.0
## Entity's speed.
@export var speed 			: float = 400.0
@export_subgroup("Fixed Amount")
## Amount we want to travel when we are in FIXED_UNITS
@export var fixed_units					: float = 300.0
## How much should the travel takes
@export var fixed_duration				: float = 1.0
## Kind of interpolation for the translation when we are in FIXED_UNITS
@export var fixed_interpolation_type 	: InterpolationLibrary.EInterpolationType
## In which axis should we move the entity when we are in FIXED_UNITS
@export var fixed_axis 					: InterpolationLibrary.EAxis 

@export_group("Rotation")
## Pattern of rotation we want to follow. See ERotationType for more info
@export var rotation_type	: ERotationType = ERotationType.NO_ROTATION
@export_subgroup("Constant")
## If our pattern is CONSTANT, how many degrees per frame should we rotate
@export var rotation_degrees_per_frame 	: float = 5.0
@export_subgroup("Oriented")
## If our pattern is ORIENT_TO_MOVEMENT how quickly we should orient to the movement
@export var rotation_interpolation_speed 	: float = 8.0
## Offset we want to apply to the corresponding direction rotation
@export var rotation_offset					: float = 0.0

## Initial position of the entity
var initial_position 		: Vector2
## Current direction we are following
var current_direction 		: Vector2 = DIRECTION_FWD
## How much time since we start the interpolation. This is only for FIXED_UNITS
var fixed_elapsed_time		: float = 0.0
## Multiplier used for inversing the lerp in order to comeback to the initial position. This is only for FIXED_UNITS
var fixed_delta_multiplier	: float = 1.0

## Half of the width of the parent object. The parent object should have a Sprite2D or a TextureRect in order to calculate the width 
@onready var half_object_width = GameUtilityLibrary.get_node_actual_width(get_parent()) / 2.0
## Half of the height of the parent object. The parent object should have a Sprite2D or a TextureRect in order to calculate the height 
@onready var half_object_height = GameUtilityLibrary.get_node_actual_height(get_parent()) / 2.0
## Whether the parent of this component has a sprite or not in order to perform different operations
@onready var has_a_sprite = GameUtilityLibrary.get_child_node_by_class(self, "Sprite2D")

#==============================================================================
# GODOT FUNCTIONS
#==============================================================================

## Overriden ready function
##
func _ready():
	set_name.call_deferred("AutoMovementCmp")
	_select_initial_direction()
	initial_position = get_parent().position

## Overriden input function
##
func _input(event):
	if event is InputEventSingleScreenTap:
		_handle_tap()		

## Overriden physics_process function
##
func _physics_process(delta):
	if !enable: return
	
	_handle_screen_borders()
	_handle_position(delta)
	_handle_rotation(delta)
	
#==============================================================================
# PUBLIC FUNCTIONS
#==============================================================================

## In case the sizes of the parent have changed we need to call this function to make sure
## the half width and height are recalculated
##
func update_sizes() -> void:
	half_object_width = GameUtilityLibrary.get_node_actual_width(get_parent()) / 2.0
	half_object_height = GameUtilityLibrary.get_node_actual_height(get_parent()) / 2.0

#==============================================================================
# PRIVATE FUNCTIONS
#==============================================================================

## Select the initial current direction based on the type of movement pattern
##
func _select_initial_direction() -> void:
	if initial_direction != EMovementType.NO_MOVEMENT:
		movement_type = initial_direction
		return
		
	match movement_type:
		EMovementType.HORIZONTAL		: current_direction = DIRECTION_RIGHT
		EMovementType.VERTICAL			: current_direction = DIRECTION_FWD
		EMovementType.FWD				: current_direction = DIRECTION_FWD
		EMovementType.LEFT				: current_direction = DIRECTION_LEFT
		EMovementType.BWD				: current_direction = DIRECTION_BWD
		EMovementType.RIGHT				: current_direction = DIRECTION_RIGHT
		EMovementType.DIAGONAL_LEFT		: current_direction = DIRECTION_FWD_LEFT
		EMovementType.DIAGONAL_RIGHT	: current_direction = DIRECTION_FWD_RIGHT
		EMovementType.FWD_LEFT			: current_direction = DIRECTION_FWD_LEFT
		EMovementType.FWD_RIGHT			: current_direction = DIRECTION_FWD_RIGHT
		EMovementType.BWD_LEFT			: current_direction = DIRECTION_BWD_LEFT
		EMovementType.BWD_RIGHT			: current_direction = DIRECTION_BWD_RIGHT

## Called when we should trigger a movement change. Depending on the movemenet pattern,
## we will trigger direction changes
##	
func _change_movement() -> void:
	match movement_type:
		EMovementType.HORIZONTAL		: _change_horizontal()
		EMovementType.VERTICAL			: _change_vertical()
		EMovementType.DIAGONAL_LEFT		: _change_diagonal_left()		
		EMovementType.DIAGONAL_RIGHT	: _change_diagonal_right()

## Change when we are in the HORIZONTAL pattern.
##		
func _change_horizontal() -> void:
	if current_direction == DIRECTION_LEFT: current_direction = DIRECTION_RIGHT
	else: current_direction = DIRECTION_LEFT

## Change when we are in the VERTICAL pattern.
##				
func _change_vertical() -> void:
	if current_direction == DIRECTION_FWD: current_direction = DIRECTION_BWD
	else: current_direction = DIRECTION_FWD

## Change when we are in the DIAGONAL_LEFT pattern.
##		
func _change_diagonal_left() -> void:
	if current_direction == DIRECTION_FWD_LEFT: current_direction = DIRECTION_BWD_RIGHT
	else: current_direction = DIRECTION_FWD_LEFT

## Change when we are in the DIAGONAL_RIGHT pattern.
##			
func _change_diagonal_right() -> void:
	if current_direction == DIRECTION_FWD_RIGHT: current_direction = DIRECTION_BWD_LEFT
	else: current_direction = DIRECTION_FWD_RIGHT

## Whether once we have started the movement, the script can change dynamically the direction of the entity.
## This will be only possible if we are using some specific movement patterns
##
func _is_direction_changeable() -> bool:
	if change_type == EChangeType.NO_CHANGE: return false
	if movement_type != EMovementType.HORIZONTAL and movement_type != EMovementType.VERTICAL and movement_type != EMovementType.DIAGONAL_LEFT and movement_type != EMovementType.DIAGONAL_RIGHT: return false
	
	return true	

## Handles the logic that should happen when a input tap happens
##	
func _handle_tap() -> void:
	if(!_is_direction_changeable()): return
	if(change_type != EChangeType.INPUT_TAP): return
	
	_change_movement()

## Handles the logic that should happen when the entity has touched the screen borders
##		
func _handle_screen_borders() -> void:
	if(!_is_direction_changeable()): return
	if(change_type != EChangeType.SCREEN_HEIGHT and change_type != EChangeType.SCREEN_WIDHT): return
	
	var position_parent = get_parent().position 
	
	match change_type:
		EChangeType.SCREEN_WIDHT:
			if has_a_sprite:		
				if (position_parent.x + half_object_width > GameUtilityLibrary.SCREEN_WIDTH): _change_movement()
				if (position_parent.x - half_object_width < 0.0): _change_movement()
			else:
				if (position_parent.x + (half_object_width * 2) > GameUtilityLibrary.SCREEN_WIDTH): _change_movement()
				if (position_parent.x < 0.0): _change_movement()			
		EChangeType.SCREEN_HEIGHT:
			if has_a_sprite:					
				if (position_parent.y + half_object_height > GameUtilityLibrary.SCREEN_HEIGHT): _change_movement()
				if (position_parent.y - half_object_height < 0.0): _change_movement()
			else:
				if (position_parent.y + (half_object_height * 2) > GameUtilityLibrary.SCREEN_HEIGHT): _change_movement()
				if (position_parent.y < 0.0): _change_movement()		

## Handles the position of the entity depending on the movement patterns
##	
func _handle_position(delta) -> void:
	if movement_type == EMovementType.NO_MOVEMENT: return
	
	if movement_type == EMovementType.FIXED_UNITS:
		_handle_fixed_units_position(delta)
		return
		
	var velocity = current_direction * speed * delta
	get_parent().position += velocity

## In case our movement pattern is set to FIXED_UNITS, we will execute a specific type of movement
##
func _handle_fixed_units_position(delta) -> void:
	if (fixed_elapsed_time >= fixed_duration or fixed_elapsed_time < 0):
		fixed_delta_multiplier *= -1
	
	fixed_elapsed_time += delta * fixed_delta_multiplier
	var alpha = clamp(fixed_elapsed_time / fixed_duration, 0.0, 1.0)
	
	var vector_amount = Vector2(fixed_units, 0) if fixed_axis == InterpolationLibrary.EAxis.X else Vector2(0, -fixed_units)	
	var target_position = initial_position + vector_amount 
	get_parent().position = lerp(initial_position, target_position, alpha)

## Handles the rotation of the entity depending on the rotation patterns
##		
func _handle_rotation(delta) -> void:
	if rotation_type == ERotationType.NO_ROTATION: return

	match rotation_type:
		ERotationType.NO_ROTATION: return
		ERotationType.CONSTANT: 
			get_parent().rotation_degrees += rotation_degrees_per_frame
		ERotationType.ORIENTED_TO_MOVEMENT:
			var dot = DIRECTION_FWD.dot(current_direction)
			var det = DIRECTION_FWD.x * current_direction.y - current_direction.x * DIRECTION_FWD.y
			var target_angle = atan2(det, dot)
			var offset_angle = rotation_offset if target_angle > 0 else -rotation_offset
			var final_target_angle = target_angle + deg_to_rad(offset_angle)
			get_parent().rotation = InterpolationLibrary.interp_to(get_parent().rotation, final_target_angle, delta, rotation_interpolation_speed) 

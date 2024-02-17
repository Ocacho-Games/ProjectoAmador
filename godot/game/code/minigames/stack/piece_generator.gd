extends Node

#==============================================================================
# TYPES
#==============================================================================

## Class to represent a piece reference and its y spawn position. For interpolation purpouses
class PieceRefStruct:
	var piece_node : Node2D
	var spawn_y_position: float
	
#==============================================================================
# VARIABLES
#==============================================================================

## Whether the generator is enabled or not
@export var enable : bool = false
## Piece to spawn
@export var piece: PackedScene
## Reference to the initial piece of the scene
@export var initial_piece : Node2D
## Reference to the floor in order to displace it
@export var floor_ref : Node2D
## Initial speed for the pieces. This will be increased along the time
@export var piece_base_speed = 400
## In case the difference between the current and the last piece stacked are less than this, we will place the stack perfectly
@export var tolerated_error_difference : float = 15.0
## Number of pieces stacked in order to start doing the climbing feel
@export var num_pieces_to_climb : int = 15
## Interpolation speed for climbing feeling
@export var climb_interp_speed : float = 8.0

## Reference to the current piece we are stacking
@onready var current_piece_node : Node2D = initial_piece
## Position of the last piece stacked
var last_piece_position : Vector2
## Floor target position for interpolation
@onready var floor_ref_target_y_position = floor_ref.position.y

## Whether we should spawn the piece from the left or from the right
var spawn_piece_left : bool = true 

## Size of the next texture rect's size of the next spawned piece
@onready var next_x_size : float = initial_piece.get_node("TextureRect").size.x
## Speed of the current piece. This is variable 
var piece_speed : float = piece_base_speed

## Num of pieces placed. This is useful for the score of the minigame
var pieces_placed : int = 0

## Reference to all the pieces in the stack
var piece_nodes_array: Array[PieceRefStruct] 

#==============================================================================
# SIGNALS
#==============================================================================
## Fired when we can no longer place new pieces 
signal on_finished_game

#==============================================================================
# GODOT FUNCTIONS
#==============================================================================

## Overriden ready function
##
func _ready():
	assert(initial_piece, "Initial piece must be valid")
	assert(floor_ref, "Floor must be valid")
	
	_add_piece_to_array(initial_piece)
	_create_and_place_piece()	

## Overriden process function
##
func _process(delta):
	_balance_level_difficulty()
	_interpolate_pieces(delta)

## Overriden input function
##
func _input(event):
	if event is InputEventSingleScreenTap:
		_cut_place_current_piece()
		current_piece_node.get_node("AutoMovementCmp").enable = false
		_create_and_place_piece()	

#==============================================================================
# PRIVATE FUNCTIONS
#==============================================================================
		
## Based on the score of the minigame, increase the speed of the pieces a.k.a the difficulty of the level
##
func _balance_level_difficulty() -> void:
	if pieces_placed > 40:
		piece_speed = piece_base_speed * 3.0
		return
	if pieces_placed > 30:
		piece_speed = piece_base_speed * 2.2
		return
	if pieces_placed > 20:
		piece_speed = piece_base_speed * 1.7
		return
	if pieces_placed > 10:
		piece_speed = piece_base_speed * 1.2

## Interpolate the y coordinate of the pieces if necessary in order to provide a nice climbing feeling.
##
func _interpolate_pieces(delta) -> void:
	floor_ref.position.y = InterpolationLibrary.interp_to(floor_ref.position.y, floor_ref_target_y_position, delta, climb_interp_speed)
	
	for one_piece in piece_nodes_array:
		if one_piece.piece_node != null:
			one_piece.piece_node.position.y = InterpolationLibrary.interp_to(one_piece.piece_node.position.y, one_piece.spawn_y_position, delta, climb_interp_speed)

## Performs all the logic for instanciating and setting the proper values to a new piece
##
func _create_and_place_piece() -> void:
	if current_piece_node:
		last_piece_position = current_piece_node.position
		if piece_nodes_array.size() >= num_pieces_to_climb:
			# Offseting the reference last position for new piece if climbing 
			last_piece_position.y += GameUtilityLibrary.get_node_actual_height(current_piece_node)
	
	var piece_node = piece.instantiate()
	get_parent().call_deferred("add_child", piece_node)
	
	_set_piece_size_position_speed(piece_node)	
	_add_piece_to_array(piece_node)
	
	current_piece_node = piece_node
	spawn_piece_left = !spawn_piece_left
	pieces_placed += 1						

## Set the size, position and speed of the given piece, in that order
## [piece_node]: Valid piece 
##
func _set_piece_size_position_speed(piece_node : Node2D) -> void:
	assert(piece_node)
	
	var auto_movement_cmp = GameUtilityLibrary.get_child_node_by_class_or_name(piece_node, "AutoMovementCmp")
	assert(auto_movement_cmp, "Pieces must have an AutoMovementCmp")
	piece_node.get_node("TextureRect").size.x = next_x_size
	auto_movement_cmp.update_sizes()	
	
	if !spawn_piece_left:
		piece_node.position.x = GameUtilityLibrary.SCREEN_WIDTH - GameUtilityLibrary.get_node_actual_width(piece_node)
		auto_movement_cmp.current_direction = AutoMovementCmp.DIRECTION_LEFT		
	piece_node.position.y = last_piece_position.y - GameUtilityLibrary.get_node_actual_height(piece_node)

	auto_movement_cmp.speed = piece_speed

## Add a valid piece node (Node2D) reference to the array storing the pieces from the stack
## [piece_node]: Valid piece 
##
func _add_piece_to_array(piece_node : Node2D) -> void:
	assert(piece_node)
	
	var piece_ref_struct = PieceRefStruct.new()
	piece_ref_struct.piece_node = piece_node
	piece_ref_struct.spawn_y_position = piece_node.position.y
	piece_nodes_array.append(piece_ref_struct)

## In case at least two pieces are created, check if we need to resize the current piece and place it in the right position
## We use a threshold in order to "forgive" a mistake from the player in order to improve the user experience.
## It also updates the next x size for the next piece
##	
func _cut_place_current_piece()-> void:
	var x_difference = abs(last_piece_position.x - current_piece_node.position.x)
	if x_difference <= tolerated_error_difference: x_difference = 0.0
		
	var texture_rect = current_piece_node.get_node("TextureRect")
	texture_rect.size.x -= x_difference
	next_x_size = texture_rect.size.x
	
	if next_x_size <= 0:
		on_finished_game.emit()
	
	var should_cut_from_left = last_piece_position.x > current_piece_node.position.x
	if should_cut_from_left:
		current_piece_node.position.x = last_piece_position.x
	else:		
		current_piece_node.position.x = last_piece_position.x + x_difference
		
	_displace_whole_stack()
	
## In case we want to start the climbing feel, every time we instantiate a new piece we displace all the stack
## We also delete the null references to older pieces
##	
func _displace_whole_stack()-> void:
	if piece_nodes_array.size() < num_pieces_to_climb: return
	
	var piece_height = GameUtilityLibrary.get_node_actual_height(current_piece_node)
	floor_ref_target_y_position += piece_height
	
	for one_piece in piece_nodes_array:
		if one_piece.piece_node != null:
			one_piece.spawn_y_position += piece_height
		else:
			piece_nodes_array.erase(one_piece)

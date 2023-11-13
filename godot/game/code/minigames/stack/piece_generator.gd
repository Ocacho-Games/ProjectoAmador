extends Node

@export var piece: PackedScene 
@export var piece_destructible : PackedScene

var current_piece_node : Node2D
var last_piece_node : Node2D

var initial_piece_y_position = ProjectSettings.get_setting("display/window/size/viewport_height")	
var last_piece_y_position : float = 0

var next_x_size : float = 0

@export var enable : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	last_piece_y_position = initial_piece_y_position
	_create_first_piece()	

func _input(event):
	if event is InputEventSingleScreenTap:
		_check_piece_difference()
		if current_piece_node:
			current_piece_node.get_node("AutoMovementCmp").enable = false
			_instantiate_piece()
	
	
func _create_first_piece():
	var piece_node = piece.instantiate()
	piece_node.position.x = GameUtilityLibrary.get_node_actual_width(piece_node) / 2.0
	piece_node.position.y = last_piece_y_position - GameUtilityLibrary.get_node_actual_height(piece_node)
	next_x_size = piece_node.get_node("TextureRect").size.x
	last_piece_y_position = piece_node.position.y
	get_parent().call_deferred("add_child", piece_node)	
	current_piece_node = piece_node			
	
	
func _instantiate_piece():
	last_piece_node = current_piece_node
	
	var piece_node = piece.instantiate()
	piece_node.position.x = GameUtilityLibrary.get_node_actual_width(piece_node) / 2.0
	piece_node.position.y = last_piece_y_position - GameUtilityLibrary.get_node_actual_height(piece_node)
	piece_node.get_node("TextureRect").size.x = next_x_size
	last_piece_y_position = piece_node.position.y
	get_parent().call_deferred("add_child", piece_node)	
	current_piece_node = piece_node		

	
func _check_piece_difference():
	if !last_piece_node or !current_piece_node: return
	
	var x_difference = abs(last_piece_node.position.x - current_piece_node.position.x)
	
	var texture_rect = current_piece_node.get_node("TextureRect")
	texture_rect.size.x -= x_difference
	next_x_size = texture_rect.size.x
	
	var should_cut_from_left = last_piece_node.position.x > current_piece_node.position.x
	if should_cut_from_left:
		current_piece_node.position.x = last_piece_node.position.x
	#else:		
	#	current_piece_node.position.x = last_piece_node.position.x + GameUtilityLibrary.get_node_actual_width(last_piece_node) / 2
	
	#if texture_rect.size.x < 0:
		# next minigame


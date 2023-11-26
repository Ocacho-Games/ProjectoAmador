extends Node2D

#==============================================================================
# TYPES
#==============================================================================

## Type of trails that can be showed
enum TrailType
{
	Linear,
	Parabolic
}

#==============================================================================
# VARIABLES
#==============================================================================

## GUI Type of trail
@export var trail_type : TrailType

## GUI Range Number of point for the trail
@export_range(10, 30, 1) var point_numbers = 10

## GUI Max Point Size Value
@export var max_point_size = 5.0

## GUI Distance between the trail points
@export_range(0.0, 0.5, 0.005) var point_distance : float = 0.05

## Ball game node
@onready var ball : RigidBody2D = get_parent().get_node("RigidBody2D")
## Origin position of the ball
@onready var origin_ball : Vector2 = ball.position

## User Input Vector value
var input_vec	: Vector2 = Vector2(0.0,0.0)
## Trail Vector Direction value
var trail_dir	: Vector2 = Vector2(0.0,0.0)
## Point collision value
var point_collide  	: bool = false
## Array of points 
var point_array : PackedVector2Array

#==============================================================================
# GODOT FUNCTIONS
#==============================================================================

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(_delta):
	if visible :
		_calculate_point_trail()
		queue_redraw()

func _draw():
	var point_size = max_point_size
	var i = 1.0
	for point in point_array :
		draw_circle( point, point_size, Color.BLACK )
		point_size = _calculate_next_point_size( i )
		i = i + 1.0

#==============================================================================
# PUBLIC FUNCTIONS
#==============================================================================

# Sets the input vector for the trail
func input_value( vector_dir : Vector2 ):
	input_vec = vector_dir
	if vector_dir.length() <= 5.0 :
		_make_invisible()
		return
	_make_visible()

#==============================================================================
# PRIVATE FUNCTIONS
#==============================================================================

# Set the trail to Visible
func _make_visible():
	visible = true

# Set the trail to invisible
func _make_invisible():
	visible = false

# Calculates the trail of points
func _calculate_point_trail():
	point_array.clear()
	trail_dir	= input_vec
	point_collide	= false
	if trail_type == TrailType.Linear :
		_linear_trail()
	elif trail_type == TrailType.Parabolic :
		_parabolic_trail()
	ball.position = origin_ball

# Calculates a linear trail of points
func _linear_trail():
	point_array.append(origin_ball)
	for i in point_numbers :
		if point_collide :
			return
		var point_pos = _next_point_linear_pos(i)
		point_array.append(point_pos)

# Calculates a point for a linear trail
func _next_point_linear_pos( i ):
	var distance = float(i) * point_distance
	var x = distance * trail_dir.x
	var y = distance * trail_dir.y
	
	var point_position = Vector2(x,y)
	_check_trail_collision(position)
	
	return point_position

# Calculates a parabolic trail of points
func _parabolic_trail():
	point_array.append(origin_ball)
	for i in point_numbers :
		if point_collide :
			return
		var point_pos = _next_point_parabolic_pos(i)
		point_array.append(point_pos)

# Calculates a point for a parabolic trail
func _next_point_parabolic_pos( i ):
	var time = float(i) * point_distance
	var x = time * trail_dir.x
	var y = time * trail_dir.y + 0.5 * 980.0 * pow(time,2.0)
	
	var next_pos = Vector2(x,y)
	_check_trail_collision(next_pos)
	
	return next_pos

# Checks the point trail collision
func _check_trail_collision( pos : Vector2 ):
	ball.position = pos
	var info = ball.move_and_collide(Vector2(0.0,0.0), true)
	if info != null :
		point_collide = true
	ball.position = origin_ball

# Calculates the next point size
func _calculate_next_point_size( i ):
	var scalar_size = (float(point_numbers) - i)/float(point_numbers)
	return max_point_size * scalar_size

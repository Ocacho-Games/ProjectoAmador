extends Minigame

#==============================================================================
# VARIABLES
#==============================================================================

# Ball node
@onready var ball_node = $ball_entity;
# Basket node
@onready var basket_node = $basket_entity;
# Point trail node
@onready var trail_point = $ball_entity/point_trail

# Radius of the ball
@onready var ball_radius = ball_node.get_node("RigidBody2D/CollisionShape2D").get_shape().get_radius()
# Size of the basket
@onready var half_basket_size = basket_node.get_node("basketRing/sprite_basket").get_rect().size / 2.0

#Offset position from the screen borders
@export var offset_screen = 40.0
#Radius ball offset
@export var ball_radius_check_offset = 15.0

# Bool value to know if it's pressed
var is_pressed : bool = false
# Initial dragging position
var init_drag_position	: Vector2 = Vector2( 0.0 , 0.0 )
# Current dragging position
var curr_drag_position	: Vector2 = Vector2( 0.0 , 0.0 )
# Drag vector released
var last_drag_vector		: Vector2 = Vector2( 0.0 , 0.0 )

# Trail vector scale factor
@export var trail_factor = 5.0
# Impulse ball force factor
@export var impulse_ball_factor = 3.8

#==============================================================================
# GODOT FUNCTIONS
#==============================================================================

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	
	gps_leader_board_id = "CgkIr7WWkr4cEAIQAQ"
	_move_random_location_entities()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	
	var is_ball_thrown = ball_node.thrown
	if !is_ball_thrown and SInputUtility.is_dragging.value :
		var event = SInputUtility.cached_drag_event
		if !is_pressed :
			is_pressed = _check_action_in_ball(event.position)
			init_drag_position.x = -event.position.x
			init_drag_position.y = -event.position.y
		else :
			curr_drag_position.x = -event.position.x
			curr_drag_position.y = -event.position.y
			last_drag_vector = curr_drag_position - init_drag_position
			trail_point.input_value(last_drag_vector * trail_factor)
	elif !is_ball_thrown and SInputUtility.is_dragging.has_changed(false) :
		trail_point.input_value(Vector2( 0.0 , 0.0 ))
		var last_drag_pos_GD_space = Vector2(-curr_drag_position.x,-curr_drag_position.y)
		var released_in_ball = _check_action_in_ball(last_drag_pos_GD_space)
		if !released_in_ball :
			ball_node.throw(last_drag_vector * impulse_ball_factor)
	
	if SInputUtility.is_dragging.has_changed(false) :
		is_pressed = false

## Overriden exit tree function
##
func _exit_tree():
	super._exit_tree()

#==============================================================================
# PRIVATE FUNCTIONS
#==============================================================================

# Moves the basket and the ball to a random position
func _move_random_location_entities():
	var width = GameUtilityLibrary.SCREEN_WIDTH
	var height = GameUtilityLibrary.SCREEN_HEIGHT
	
	var min_X_basket_range = offset_screen + half_basket_size.x
	var max_X_basket_range = width - half_basket_size.x - offset_screen
	var min_Y_basket_range = offset_screen + half_basket_size.x
	var max_Y_basketrange = height - half_basket_size.y - offset_screen
	
	var basket_X_rand = randf_range( min_X_basket_range , max_X_basket_range )
	var basket_Y_rand = randf_range( min_Y_basket_range , max_Y_basketrange )
	var basket_rand_pos = Vector2(basket_X_rand, basket_Y_rand)
	
	basket_node.position = basket_rand_pos
	
	var ball_Y_rand = randf_range( ball_radius + offset_screen , height - ball_radius - offset_screen )
	
	var range_left_min = ball_radius + offset_screen
	var range_left_max = basket_rand_pos.x - half_basket_size.x - ball_radius * 2.0
	var range_right_min = basket_rand_pos.x + half_basket_size.x + ball_radius * 2.0 
	var range_right_max = width - ball_radius - offset_screen
	
	var min_size_spawn = ball_radius * 3
	
	if range_left_max - range_left_min < min_size_spawn :
		var ball_X_rand = randf_range( range_right_min , range_right_max )
		ball_node.position = Vector2(ball_X_rand, ball_Y_rand)
	elif range_right_max - range_right_min < min_size_spawn :
		var ball_X_rand = randf_range( range_left_min , range_left_max )
		ball_node.position = Vector2(ball_X_rand, ball_Y_rand)

# Checks if the given position collides with the basketball
func _check_action_in_ball( pos : Vector2 ):
	var ball_pos = ball_node.position
	
	var radius_check = ball_radius + ball_radius_check_offset
	
	var min_X = ball_pos.x - ball_radius
	var max_X = ball_pos.x + ball_radius
	var min_Y = ball_pos.y - ball_radius
	var max_Y = ball_pos.y + ball_radius
	
	var x_bound = pos.x >= min_X and pos.x <= max_X
	var y_bound = pos.y >= min_Y and pos.y <= max_Y
	
	return x_bound and y_bound

#==============================================================================
# REEL FUNCTIONS
#==============================================================================
func can_drag_from_reel() -> bool:
	if is_pressed and SInputUtility.is_dragging.has_changed(false) : return false
	
	var event = SInputUtility.cached_drag_event
	if event == null : return true
	
	if _check_action_in_ball(event.position) or is_pressed : return false
	
	return true

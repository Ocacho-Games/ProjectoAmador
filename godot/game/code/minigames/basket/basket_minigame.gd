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
@export var offset_screen = 10.0

# Bool value to know if it's pressed
var is_pressed : bool = false
# Initial dragging position
var init_drag_position	: Vector2 = Vector2( 0.0 , 0.0 )
# Current dragging position
var curr_drag_position	: Vector2 = Vector2( 0.0 , 0.0 )
# Drag vector released
var last_drag_vector		: Vector2 = Vector2( 0.0 , 0.0 )

# Trail vector scale factor
@export var trail_factor = 3.0
# Impulse ball force factor
@export var impulse_ball_factor = 2.3

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
		var lastDragPosGDSpace = Vector2(-curr_drag_position.x,-curr_drag_position.y)
		var releasedInBall = _check_action_in_ball(lastDragPosGDSpace)
		if !releasedInBall :
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
	
	var minXBasketRange = offset_screen + half_basket_size.x
	var maxXBasketRange = width - half_basket_size.x - offset_screen
	var minYBasketRange = offset_screen + half_basket_size.x
	var maxYBasketRange = height - half_basket_size.y - offset_screen
	
	var basketXRand = randf_range( minXBasketRange , maxXBasketRange )
	var basketYRand = randf_range( minYBasketRange , maxYBasketRange )
	var basketRandPos = Vector2(basketXRand, basketYRand)
	
	basket_node.position = basketRandPos
	
	var ballYRand = randf_range( ball_radius + offset_screen , height - ball_radius - offset_screen )
	
	var range_left_min = ball_radius + offset_screen
	var range_left_max = basketRandPos.x - half_basket_size.x - ball_radius * 2.0
	var range_right_min = basketRandPos.x + half_basket_size.x + ball_radius * 2.0 
	var range_right_max = width - ball_radius - offset_screen
	
	var min_size_spawn = ball_radius * 3
	
	if range_left_max - range_left_min < min_size_spawn :
		var ballXRand = randf_range( range_right_min , range_right_max )
		ball_node.position = Vector2(ballXRand, ballYRand)
	elif range_right_max - range_right_min < min_size_spawn :
		var ballXRand = randf_range( range_left_min , range_left_max )
		ball_node.position = Vector2(ballXRand, ballYRand)

# Checks if the given position collides with the basketball
func _check_action_in_ball( pos : Vector2 ):
	var ballPos = ball_node.position
	
	var minX = ballPos.x - ball_radius
	var maxX = ballPos.x + ball_radius
	var minY = ballPos.y - ball_radius
	var maxY = ballPos.y + ball_radius
	
	var xBound = pos.x >= minX and pos.x <= maxX
	var yBound = pos.y >= minY and pos.y <= maxY
	
	return xBound and yBound

#==============================================================================
# REEL FUNCTIONS
#==============================================================================
func can_drag_from_reel() -> bool:
	if is_pressed and SInputUtility.is_dragging.has_changed(false) : return false
	
	var event = SInputUtility.cached_drag_event
	if event == null : return true
	
	if _check_action_in_ball(event.position) or is_pressed : return false
	
	return true

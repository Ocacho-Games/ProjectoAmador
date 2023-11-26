extends Minigame

#==============================================================================
# VARIABLES
#==============================================================================

# Ball node
@onready var ballNode = $ball_entity;
# Basket node
@onready var basketNode = $basket_entity;
# Point trail node
@onready var trailPoint = $ball_entity/point_trail

# Radius of the ball
@onready var ballRadius = ballNode.get_node("RigidBody2D/CollisionShape2D").get_shape().get_radius()
# Size of the basket
@onready var halfBasketSize = basketNode.get_node("basketRing/sprite_basket").get_rect().size / 2.0

#Offset position from the screen borders
var offsetScreen = 10.0

# Bool value to know if it's pressed
var isPressed : bool = false
# Initial dragging position
var initDragPosition	: Vector2 = Vector2( 0.0 , 0.0 )
# Current dragging position
var currDragPosition	: Vector2 = Vector2( 0.0 , 0.0 )
# Drag vector released
var lastDragVector		: Vector2 = Vector2( 0.0 , 0.0 )

# Trail vector scale factor
var trailFactor = 3.0
# Impulse ball force factor
var impulseBallFactor = 2.3

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
	
	var isBallThrown = ballNode.get_thrown()
	if !isBallThrown and SInputUtility.is_dragging.value :
		var event = SInputUtility.cached_drag_event
		if !isPressed :
			isPressed = _check_action_in_ball(event.position)
			initDragPosition.x = -event.position.x
			initDragPosition.y = -event.position.y
		else :
			currDragPosition.x = -event.position.x
			currDragPosition.y = -event.position.y
			lastDragVector = currDragPosition - initDragPosition
			trailPoint.input_value(lastDragVector * trailFactor)
	elif !isBallThrown and SInputUtility.is_dragging.has_changed(false) :
		trailPoint.input_value(Vector2( 0.0 , 0.0 ))
		var lastDragPosGDSpace = Vector2(-currDragPosition.x,-currDragPosition.y)
		var releasedInBall = _check_action_in_ball(lastDragPosGDSpace)
		if !releasedInBall :
			ballNode.throw(lastDragVector * impulseBallFactor)
	
	if SInputUtility.is_dragging.has_changed(false) :
		isPressed = false

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
	
	var minXBasketRange = offsetScreen + halfBasketSize.x
	var maxXBasketRange = width - halfBasketSize.x - offsetScreen
	var minYBasketRange = offsetScreen + halfBasketSize.x
	var maxYBasketRange = height - halfBasketSize.y - offsetScreen
	
	var basketXRand = randf_range( minXBasketRange , maxXBasketRange )
	var basketYRand = randf_range( minYBasketRange , maxYBasketRange )
	var basketRandPos = Vector2(basketXRand, basketYRand)
	
	basketNode.position = basketRandPos
	
	var ballYRand = randf_range( ballRadius + offsetScreen , height - ballRadius - offsetScreen )	
	
	var range_left_min = ballRadius + offsetScreen
	var range_left_max = basketRandPos.x - halfBasketSize.x - ballRadius * 2.0
	var range_right_min = basketRandPos.x + halfBasketSize.x + ballRadius * 2.0 
	var range_right_max = width - ballRadius - offsetScreen
	
	var min_size_spawn = ballRadius * 3
	
	if range_left_max - range_left_min < min_size_spawn :
		var ballXRand = randf_range( range_right_min , range_right_max )
		ballNode.position = Vector2(ballXRand, ballYRand)
	elif range_right_max - range_right_min < min_size_spawn :
		var ballXRand = randf_range( range_left_min , range_left_max )
		ballNode.position = Vector2(ballXRand, ballYRand)

# Checks if the given position collides with the basketball
func _check_action_in_ball( pos : Vector2 ):
	var ballPos = ballNode.position
	
	var minX = ballPos.x - ballRadius
	var maxX = ballPos.x + ballRadius
	var minY = ballPos.y - ballRadius
	var maxY = ballPos.y + ballRadius
	
	var xBound = pos.x >= minX and pos.x <= maxX
	var yBound = pos.y >= minY and pos.y <= maxY
	
	return xBound and yBound

#==============================================================================
# REEL FUNCTIONS
#==============================================================================
func can_drag_from_reel() -> bool:
	if isPressed and SInputUtility.is_dragging.has_changed(false) :
		return false
	
	var event = SInputUtility.cached_drag_event
	if event == null :
		return true
	
	if _check_action_in_ball(event.position) or isPressed :
		return false
	
	return true

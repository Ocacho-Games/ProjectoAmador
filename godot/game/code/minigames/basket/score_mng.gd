extends Node2D

#==============================================================================
# VARIABLES
#==============================================================================

@onready var score_checker : Area2D = $Area2D
@onready var score_box	  : CollisionShape2D = $Area2D/scoreChecker

var score_up_vector : Vector2
var under_basket_score : bool = false

#==============================================================================
# GODOT FUNCTIONS
#==============================================================================
# Called when the node enters the scene tree for the first time.
func _ready():
	score_checker.body_entered.connect(_check_ball_collision)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var radians = global_rotation
	score_up_vector = Vector2(0.0,1.0).rotated(radians)
	score_up_vector.x = score_up_vector.x * -1.0 
	score_up_vector = score_up_vector.normalized()

#==============================================================================
# PRIVATE FUNCTIONS
#==============================================================================

# Checks if the colling entity is the ball
func _check_ball_collision( ball ):
	if ball.get_parent().name == "ball_entity" :
		_check_score(ball)

# Function that checks if the player missed or not the shoot
func _check_score( ball ):
	var ball_pos = ball.global_position
	var check_pos = score_checker.global_position
	var ball_checker_vec = ball_pos - check_pos
	
	ball_pos.y = ball_pos.y * -1.0
	check_pos.y = check_pos.y * -1.0
	ball_checker_vec = ball_checker_vec.normalized()
	
	var dot_score = ball_checker_vec.dot(score_up_vector)
	
	if dot_score > 0.0 :
		if !under_basket_score :
			_score()
	else :
		under_basket_score = true
		_fail_shoot()

# Function called when scored
func _score():
	var game_base = get_parent()
	game_base.on_should_change_to_next_minigame.emit()

# Function called when shoot was failed
func _fail_shoot():
	var game_base = get_parent()
	game_base.on_should_change_to_next_minigame.emit()

extends Minigame

@onready var spaceship = $spaceship_player
@onready var obstacle_generator = $obstacle_generator

# TEMPORAL
var last_coins_score = 50

#==============================================================================
# GODOT FUNCTIONS
#==============================================================================

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()	
	
	gps_leader_board_id = "CgkIr7WWkr4cEAIQAg"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	
	if SInputUtility.is_tapping.value:
		spaceship.get_node("AutoMovementCmp").enable = true
	
	score += delta * 7.5
	_check_for_screen_collision()
	
	if score > last_coins_score:
		SGPS.add_coins(10)
		last_coins_score = score + 50

#==============================================================================
# PRIVATE FUNCTIONS
#==============================================================================

##
##
func _check_for_screen_collision() -> void:
	if spaceship.position.x > GameUtilityLibrary.SCREEN_WIDTH: on_should_change_to_next_minigame.emit() 
	if spaceship.position.x < 0: on_should_change_to_next_minigame.emit() 

##
##	
func _on_player_area_entered(_area):
	spaceship.get_node("AutoMovementCmp").enable = false	
	on_should_change_to_next_minigame.emit()

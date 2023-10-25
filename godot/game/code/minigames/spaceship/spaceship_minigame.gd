extends Minigame

@onready var spaceship = $spaceship

#==============================================================================
# GODOT FUNCTIONS
#==============================================================================

# Called when the node enters the scene tree for the first time.
func _ready():
	gps_leader_board_id = "CgkIr7WWkr4cEAIQAg"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	score += delta * 7.5
	_check_for_screen_collision()

#==============================================================================
# PRIVATE FUNCTIONS
#==============================================================================

func _check_for_screen_collision() -> void:
	if spaceship.position.x > ProjectSettings.get_setting("display/window/size/viewport_width"): on_should_change_to_next_minigame.emit() 
	if spaceship.position.x < 0: on_should_change_to_next_minigame.emit() 
	

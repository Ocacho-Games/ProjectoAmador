extends Minigame

#==============================================================================
# GODOT FUNCTIONS
#==============================================================================

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	gps_leader_board_id = "CgkIr7WWkr4cEAIQAw"
	
#==============================================================================
# SIGNAL FUNCTIONS
#==============================================================================

func _on_clicker_button_pressed():
	score += 1

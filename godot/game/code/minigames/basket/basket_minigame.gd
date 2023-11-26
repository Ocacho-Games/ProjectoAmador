extends Minigame


#==============================================================================
# GODOT FUNCTIONS
#==============================================================================

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
#	score = SGPS.data_to_save.dictionary["clicker_score"]
	
	gps_leader_board_id = "CgkIr7WWkr4cEAIQAQ"
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)


## Overriden exit tree function
##			
func _exit_tree():
	super._exit_tree()
#	if is_being_played:
#		SGPS.data_to_save.dictionary["clicker_score"] = score
#		SGPS.save_game()

#==============================================================================
# SIGNAL FUNCTIONS
#==============================================================================

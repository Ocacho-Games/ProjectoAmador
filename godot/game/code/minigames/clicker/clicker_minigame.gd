extends Minigame

@onready var score_text : RichTextLabel = $score_sprite/RichTextLabel

#==============================================================================
# GODOT FUNCTIONS
#==============================================================================

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	score = SGPS.data_to_save.dictionary["clicker_score"]
	
	gps_leader_board_id = "CgkIr7WWkr4cEAIQAw"
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	score_text.set_text("Score: " + str(score))
	
## Overriden exit tree function
##			
func _exit_tree():
	super._exit_tree()
	if is_being_played:
		SGPS.data_to_save.dictionary["clicker_score"] = score
		SGPS.save_game()

#==============================================================================
# SIGNAL FUNCTIONS
#==============================================================================

func _on_texture_button_pressed():
	score += 1

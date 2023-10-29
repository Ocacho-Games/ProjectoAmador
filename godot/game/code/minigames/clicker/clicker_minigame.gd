extends Minigame

@onready var score_text : RichTextLabel = $RichTextLabel

#==============================================================================
# GODOT FUNCTIONS
#==============================================================================

#TODO: [David]: We need to save the game, maybe a general save game is not ideal maybe we need one per game

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	#SGPS.load_game(self)
	
	gps_leader_board_id = "CgkIr7WWkr4cEAIQAw"
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	score_text.set_text("Score: " + str(score))
	
## Overriden exit tree function
##			
func _exit_tree():
	super._exit_tree()
	#SGPS.save_game(self)	

#==============================================================================
# PRIVATE FUNCTIONS
#==============================================================================

func _on_texture_button_pressed():
	score += 1

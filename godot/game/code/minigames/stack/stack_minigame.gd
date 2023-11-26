extends Minigame

@onready var score_text : RichTextLabel = $RichTextLabel
@onready var piece_generator = $piece_generator

#==============================================================================
# GODOT FUNCTIONS
#==============================================================================

#TODO: [David]: We need to save the game, maybe a general save game is not ideal maybe we need one per game

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	gps_leader_board_id = "CgkIr7WWkr4cEAIQBA"
	piece_generator.on_finished_game.connect(func(): on_should_change_to_next_minigame.emit())
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	score = piece_generator.pieces_placed
	score_text.set_text("Score: " + str(score))
	
#==============================================================================
# PRIVATE FUNCTIONS
#==============================================================================

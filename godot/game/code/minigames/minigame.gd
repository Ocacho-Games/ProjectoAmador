## This is a tool so we are allowed to change the variables on the editor while playing
@tool

## Base class 
## This is the base class for Minigames. Mingames should extends from this 
## It contains common logic such as 
## 		- The progression bar of the minigame.
##		- The logic for firing a signal for the next game if the progress bar is 100%
##
class_name Minigame extends Control

#==============================================================================
# VARIABLES
#==============================================================================

## Reference to the background of the minigame. Each Minigame must have a background
@onready var background : ColorRect = $background

## Reference to the progress bar of the minigame. Each Minigame must have a progress bar #TODO: CHANGE THIS WHEN USING BASE_MINIGAME
@onready var time_bar : ProgressBar = $progress_bar 

## Reference to the text displaying the score of this minigame
@onready var score_text : RichTextLabel = $VBoxContainer/ScoreText

## Name (key) of this minigame. Dictated by the minigames database resource of the autoload
var key_name : String = ""

## Duration of this minigame. Dictated by the minigames database resource of the autoload
var minigame_duration = 0

## Current duration of this minigame. Used for changing scenes
var current_minigame_duration = 0

## Score of the game. This will be submitted to GPS and loaded from GPS.
var score = 0.0

## String ID related to the Google play services leaderboard for this game
var gps_leader_board_id = "CgkIr7WWkr4cEAIQAQ"

## Whether this specific minigame is being played even though is paused or whatever
var is_being_played = false

#==============================================================================
# SIGNALS
#==============================================================================

# Signal fired when we should jump to the next minigame well because the duration is done, we lost, we won... anything
signal on_should_change_to_next_minigame

#==============================================================================
# GODOT FUNCTIONS
#==============================================================================

## Overriden ready function
##
func _ready():
	_handle_background()
	
	key_name = SGame.get_minigame_name(self)			
	minigame_duration = SGame.get_minigame_duration(self)
	
	time_bar.fill_mode = ProgressBar.FILL_TOP_TO_BOTTOM 
	time_bar.size.y = GameUtilityLibrary.SCREEN_HEIGHT 			
	if minigame_duration == -1:
		time_bar.visible = false
	
## Overriden process function
##
func _process(delta):
	score_text.text = "[center][b]" + str(round(score)) + "[/b]" 
	
	if time_bar.visible:
		current_minigame_duration += delta
		time_bar.value = (current_minigame_duration * 100) / minigame_duration
		
		if current_minigame_duration >= minigame_duration:
			on_should_change_to_next_minigame.emit()			
				
## Overriden exit tree function
##			
func _exit_tree():
	if is_being_played:
		SGPS.submit_leaderboard_score(self, score)
		if SGPS.get_saved_data(key_name + "_score", 0) < score:
			SGPS.data_to_save_dic[key_name + "_score"] = score
			SGPS.save_game()
			
#==============================================================================
# PUBLIC FUNCTIONS
#==============================================================================

## Get the historical max score of this minigame
##
func get_max_score():
	if key_name == "":
		key_name = SGame.get_minigame_name(self)
		
	return SGPS.data_to_save_dic[key_name + "_score"]
	
## Called at the beginning from the autoload SGame. Load all the callbacks for the collectables
## This should be overridden by the children
##	
func load_collectable_callbacks() -> void:
	pass
	
#==============================================================================
# PRIVATE FUNCTIONS
#==============================================================================

## Position and scale the background image of the game if any
##
func _handle_background() -> void:
	if 	background:
		background.position = Vector2(0,0)
		background.size = Vector2(GameUtilityLibrary.SCREEN_WIDTH, GameUtilityLibrary.SCREEN_HEIGHT)
	
#==============================================================================
# SIGNAL FUNCTIONS
#==============================================================================

func _on_tutorial_button_pressed():
	pass # Replace with function body.

func _on_leaderboard_button_pressed():
	pass
		
#==============================================================================
# REEL FUNCTIONS
#==============================================================================

## Virtual method that tell us if the minigame allows the reel to drag.
## Useful when we have a minigame that needs some entity to be draggable  
##
func can_drag_from_reel() -> bool:
	return true	

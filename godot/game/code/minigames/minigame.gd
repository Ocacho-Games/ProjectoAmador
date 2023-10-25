## This is a tool so we are allowed to change the variables on the editor while playing
@tool

## Base class 
## This is the base class for Minigames. Mingames should extends from this 
## It contains common logic such as 
## 		- The progression bar of the minigame.
##		- The logic for firing a signal for the next game if the progress bar is 100%
##
class_name Minigame extends Node2D

#==============================================================================
# VARIABLES
#==============================================================================

## Reference to the progress bar of the minigame. Each Minigame must have a progress bar
@onready var TimeBar : ProgressBar = $ProgressBar 

## Duration of this minigame. Dictated by the minigames database resource of the autoload
var minigame_duration = 0

## Current duration of this minigame. Used for changing scenes
var current_minigame_duration = 0

## Score of the game. This will be submitted to GPS and loaded from GPS.
var score = 0.0

## String ID related to the Google play services leaderboard for this game
var gps_leader_board_id = "CgkIr7WWkr4cEAIQAQ"

## TODO: This shouldn't be necessary. See to change this by on load after the transition
var is_active = false

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
	TimeBar.fill_mode = ProgressBar.FILL_BEGIN_TO_END 		
	minigame_duration = SGame.get_minigame_duration(self)
	
	if minigame_duration == -1:
		TimeBar.visible = false	

## Overriden process function
##
func _process(delta):
	if is_active == false: return

	if TimeBar.visible:
		current_minigame_duration += delta
		TimeBar.value = (current_minigame_duration * 100) / minigame_duration
		
		if current_minigame_duration >= minigame_duration:
			on_should_change_to_next_minigame.emit()			
			is_active = false			

## Overriden exit tree function
##			
func _exit_tree():
	is_active = false
	#SGPS.submit_leaderboard_score(self, score)
	
#==============================================================================
# REEL FUNCTIONS
#==============================================================================

## Virtual method that tell us if the minigame allows the reel to drag.
## Useful when we have a minigame that needs some entity to be draggable  
##
func can_drag_from_reel() -> bool:
	return true	
	
## Called from the reel when this minigame is the selected one to play
##
func on_ready_from_reel() -> void:
	is_active = true


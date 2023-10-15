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

## TODO: This shouldn't be necessary. See to change this by on load after the transition
var is_active = false

#==============================================================================
# SIGNALS
#==============================================================================

# Signal fired when the minigame duration is done, so we should jump to another minigame
signal on_duration_completed

#==============================================================================
# FUNCTIONS
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
			is_active = false			
			on_duration_completed.emit()

## Overriden exit tree function
##			
func _exit_tree():
	is_active = false
	
#==============================================================================
# SCENE MANAGER FUNCTIONS
#==============================================================================
	
## Called from the game autload when this minigame is the selected one to play
##
func on_ready_from_autoload() -> void:
	is_active = true


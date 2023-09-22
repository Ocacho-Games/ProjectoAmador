## Base class 
## This is the base class for Minigames. Mingames should extends from this 
## It contains common logic such as 
## 		- The progression bar of the minigame.
##		- The logic for jumping into the next game if the progress bar is 100%
##		- The logic for swiping for next or previous minigame.
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
# FUNCTIONS
#==============================================================================

## Overriden ready function
##
func _ready():
	is_active = true
	TimeBar.fill_mode = ProgressBar.FILL_BEGIN_TO_END 		
	minigame_duration = SGame.get_minigame_duration(self)
	
	if minigame_duration == -1:
		TimeBar.visible = false

## Overriden input function
##
func _input(event):
	if event is InputEventSingleScreenSwipe:
		if event.position.y < event.relative.y:
			SGame.previous_minigame()
		else:
			SGame.next_minigame()

## Overriden process function
##
func _process(delta):
	if TimeBar.visible and is_active:
		current_minigame_duration += delta
		TimeBar.value = (current_minigame_duration * 100) / minigame_duration
		
		if current_minigame_duration >= minigame_duration:
			is_active = false
			SGame.next_minigame()
			

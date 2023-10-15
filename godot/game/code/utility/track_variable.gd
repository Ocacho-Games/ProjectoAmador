## Utility class in order to track the actual and past status of a variable.
## It is useful when you need to know if a variable has changed just once
## or you want to access the last and actual value of a variable at the same time, all wrapped into one set_value function.
## Thanks to godot, this variable can be any variable, like a template class in C++
##
class_name STrackVariable

#==============================================================================
# VARIABLES
#==============================================================================

## Actual value of the variable
var value

## Last value of the variable
var old_value

#==============================================================================
# GODOT FUNCTIONS
#==============================================================================

## Overriden init function
##
func _init(initial_value):
	set_value(initial_value)

#==============================================================================
# PUBLIC FUNCTIONS
#==============================================================================

## Set the new value for the variable, it will also update the old value
##
func set_value(new_value) -> void:
	old_value = value	
	value = new_value

## Whether the variable has changed or not comparing the value to the old_value
## [is_current_value] : Additional check for knowing if the variable now is equals to the "is_current_value"
## Ex: You want to know if a variable has changed and the new value is == true so you will use has_changed(true). Same for a number has_changed(5)
##
func has_changed(is_current_value) -> bool:
	return value != old_value and value == is_current_value 

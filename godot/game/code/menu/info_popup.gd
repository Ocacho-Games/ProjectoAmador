## Popup for showing pure information to the player
class_name InfoPopup extends Node

#==============================================================================
# VARIABLES
#==============================================================================

## Callable to call when closing the popup. Assigned on set_properties.
var callable_on_close : Callable

#==============================================================================
# GODOT FUNCTIONS
#==============================================================================

func _exit_tree():
	GameUtilityLibrary.resume_scene(get_parent())

#==============================================================================
# PUBLIC FUNCTIONS
#==============================================================================

## When instanciating the popup, you can call this function in order to set the popups' properties
##
func set_properties(text : String, callable : Callable) -> void:
	GameUtilityLibrary.get_child_node_by_class(self, "RichTextLabel").text = text
	callable_on_close = callable

#==============================================================================
# SIGNAL FUNCTIONS
#==============================================================================

## Called when the popup is closed clicking on the corner icon
## Resume the scene, calls the callback and destroy the popup
##
func _on_close_pressed():
	GameUtilityLibrary.resume_scene(get_parent())
	if callable_on_close: callable_on_close.call()
	queue_free()

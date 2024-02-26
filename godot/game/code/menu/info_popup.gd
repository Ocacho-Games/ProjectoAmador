## Popup for showing pure information to the player
class_name InfoPopup extends Node

@onready var center_container = $CenterContainer
@onready var base_popup_control = $CenterContainer/PanelContainer
@onready var close_button = $CenterContainer/PanelContainer/VBoxContainer/HBoxContainer/Close

#==============================================================================
# VARIABLES
#==============================================================================

## Callable to call when closing the popup. Assigned on set_properties.
var callable_on_close : Callable

#==============================================================================
# GODOT FUNCTIONS
#==============================================================================

func _ready():
	center_container.custom_minimum_size.x = GameUtilityLibrary.SCREEN_WIDTH
	center_container.custom_minimum_size.y = GameUtilityLibrary.SCREEN_HEIGHT * 0.75
	base_popup_control.custom_minimum_size.x = GameUtilityLibrary.SCREEN_WIDTH * 0.8

func _exit_tree():
	GameUtilityLibrary.resume_scene(get_parent())

#==============================================================================
# PUBLIC FUNCTIONS
#==============================================================================

## When instanciating the popup, you can call this function in order to set the popups' properties
##
func set_properties(text : String, callable : Callable, close_visible = true) -> void:
	GameUtilityLibrary.get_child_node_by_class_or_name(self, "RichTextLabel").text = GameUtilityLibrary.get_centered_text(text)
	GameUtilityLibrary.get_child_node_by_class_or_name(self, "Close").visible = close_visible
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

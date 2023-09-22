extends Node

#==============================================================================
# VARIABLES
#==============================================================================

## Current ID of this player for local input handling
var id_player = 0

## Input type specific to this player 
var input_type = OGLocalMultiplayerInput.EInputType.KEYBOARD

#==============================================================================
# SIGNALS
#==============================================================================

## Fired when the specifc device of the player has been connected
signal on_input_connected()
## Fired when the specific device of the player has been disconnected
signal on_input_disconnected()

#==============================================================================
# FUNCTIONS
#==============================================================================

## Overriden ready function
##
func _init():
	id_player = OGLocalMultiplayerInput.add_local_player()
	Input.joy_connection_changed.connect(_on_joy_connection_changed)

## Overriden input function
##
func _input(event):
	if event is InputEventJoypadButton || event is InputEventJoypadMotion:
		input_type = OGLocalMultiplayerInput.EInputType.GAMEPAD
	else:
		input_type = OGLocalMultiplayerInput.EInputType.KEYBOARD

## Event called when the signal joy_connection_changed is fired. 
## Depending if the joy is connected or disconnected fires on_input_connected or on_input_disconnected
## [device] : The device where the action happened
## [connected]: Whether the device is connected or not 
##
func _on_joy_connection_changed(device:int, connected:bool):
	if device == id_player:
		if connected:
			emit_signal("on_input_connected")
			Input.start_joy_vibration(device, 0.5, 0.5, 0.5)
		else:
			emit_signal("on_input_disconnected")
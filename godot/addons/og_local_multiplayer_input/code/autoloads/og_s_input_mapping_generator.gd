extends Node

#==============================================================================
# TYPES
#==============================================================================

## Type of input we can handle
enum EInputType { GAMEPAD, KEYBOARD }

#==============================================================================
# VARIABLES
#==============================================================================

## Number of current player playing the game
var actual_players 	= 0
## Last input type pressed in order to fire events 
var last_input_type = EInputType.KEYBOARD

## Number of maximum local players
const NUM_PLAYERS = 8
## Path of the local player input script for the local_player_input
const LOCAL_PLAYER_INPUT_SCRIPT = "res://addons/og_local_multiplayer_input/code/og_local_player_input.gd"

#==============================================================================
# SIGNALS
#==============================================================================

## Fired when our input has changed based on the last input received in the _input function
signal on_input_type_changed(input_type: EInputType)

#==============================================================================
# FUNCTIONS
#==============================================================================

## Overriden init function
##
func _init():
	_generate_input_mapping_for_players(InputMap.get_actions())


## Overriden input function
##
func _input(event):
	_check_on_input_changed(event)


## Creates a PlayerInput node as a child of the given parent_node. 
## The PlayerInput is in charge of handling the id of the player
## [parent_node] : Reference to the parent_node for creating the PlayerInput node
##
func create_child_player_input(parent_node):
	var child = Node.new()
	child.name = "PlayerInput"
	child.script = preload(LOCAL_PLAYER_INPUT_SCRIPT)
	parent_node.add_child(child)


## Adds 1 to the actual player num and returns the ID of the player that called this function
##
func add_local_player() -> int:
	var id_player = actual_players
	actual_players += 1
	return id_player


## Check if the PlayerInput node from the parent_node is the first player
## *create_child_player_input* must be called before calling this method!!
## [parent_node] : Reference to the parent_node containing the PlayerInput node
##
func is_first_player(parent_node) -> bool:
	return get_id_player(parent_node) == 0


## Check if the device for a PlayerInput is connected or not, based on the player_id (device_id)
## *create_child_player_input* must be called before calling this method!!
## [parent_node] : Reference to the parent_node containing the PlayerInput node
##
func is_device_connected(parent_node) -> bool:
	return Input.get_connected_joypads().find(get_id_player(parent_node)) != -1


## Calls Input.start_joy_vibration retrieving automatically the device from the PlayerInput
## *create_child_player_input* must be called before calling this method!!
## [parent_node] : Reference to the parent_node containing the PlayerInput node
##
func start_joy_vibration(parent_node, weak_magnitude: float = 0.5, strong_magnitude: float = 0.5, duration: float = 0.1):
	var id_player = parent_node.get_node("PlayerInput").id_player
	Input.start_joy_vibration(id_player, weak_magnitude, strong_magnitude, duration)


## Calls Input.stop_joy_vibration retrieving automatically the device from the PlayerInput
## *create_child_player_input* must be called before calling this method!!
## [parent_node] : Reference to the parent_node containing the PlayerInput node
##
func stop_joy_vibration(parent_node):
	var id_player = parent_node.get_node("PlayerInput").id_player
	Input.stop_joy_vibration(id_player)


## Connect the callable to the signal when the player input has been connected
## [callable]: Callable function when the event is fired
## [parent_node] : Reference to the parent_node containing the PlayerInput node
##
func connect_on_input_connected(callable: Callable, parent_node):
	parent_node.get_node("PlayerInput").on_input_connected.connect(callable)


## Connect the callable to the signal when the player input has been disconnected
## [callable]: Callable function when the event is fired
## [parent_node] : Reference to the parent_node containing the PlayerInput node
##
func connect_on_input_disconnected(callable: Callable, parent_node):
	parent_node.get_node("PlayerInput").on_input_disconnected.connect(callable)


## Returns the id of the player
## *create_child_player_input* must be called before calling this method!!
## [parent_node] : Reference to the parent_node for creating the PlayerInput node
##
func get_id_player(parent_node) -> int:
	return parent_node.get_node("PlayerInput").id_player


## Returns the actual action name for the raw action name based on the id of the player 
## *create_child_player_input* must be called before calling this method!!
## [raw_name] : Raw name of the action, if the action is "player_move_left_0" this should be "move_left"
## [parent_node] : Reference to the parent_node for creating the PlayerInput node
##
func get_action_name(raw_name: StringName, parent_node) -> StringName:
	return "player_" + raw_name + "_" + str(get_id_player(parent_node)) 


## Based on the actions that begin with "player_", duplicate those actions for the NUM_PLAYERS
## [action_names] : Action names from the InputMap
##
func _generate_input_mapping_for_players(action_names):
	for action_name in action_names:
		if action_name.begins_with("player_"):
			_add_action_for_players(action_name)


## Once we have our player actions, add the same actions to the other players
## [action_name] : Specific player action name to duplicate
##
func _add_action_for_players(action_name: StringName):
	var action_name_no_player_id = action_name.replace("_0", "")

	for id_player in NUM_PLAYERS - 1:
		var new_action_name = action_name_no_player_id + "_" + str(id_player + 1) 
		InputMap.add_action(new_action_name)
		_copy_input_events_for_player(action_name, new_action_name, id_player)


## Copy all the input events from an specific action_name to the other players
## [action_name] : Specific player action name to copy the input_events
## [new_action_name] : New action name based on the action_name and the current id_player
## [id_player] : Current id_player (or device_id, it's the same)
##
func _copy_input_events_for_player(action_name: StringName, new_action_name: StringName, id_player: int):
	for input_event in InputMap.action_get_events(action_name):
		if input_event is InputEventJoypadButton:
			var input_event_copy = input_event.duplicate()
			input_event_copy.device = id_player + 1;

			InputMap.action_add_event(new_action_name, input_event_copy)


## Check if the input type has changed from the last input event.
## If that's true, fire the *on_input_changed* event
## [input_event] : Reference to the input event from the _input function
##
func _check_on_input_changed(input_event: InputEvent):
	if input_event is InputEventJoypadButton || input_event is InputEventJoypadMotion:
		if last_input_type == EInputType.KEYBOARD:
			last_input_type = EInputType.GAMEPAD
			emit_signal("on_input_type_changed", last_input_type)
	else:
		if last_input_type == EInputType.GAMEPAD:
			last_input_type = EInputType.KEYBOARD
			emit_signal("on_input_type_changed", last_input_type)

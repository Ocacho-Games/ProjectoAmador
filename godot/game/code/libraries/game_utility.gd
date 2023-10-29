## Library that provides utility functions for the game such as pausing.
##
class_name GameUtilityLibrary

#==============================================================================
# PUBLIC FUNCTIONS
#==============================================================================

## Resume the entire given scene node. This means resuming the root node and its children
## [node]: Root node to resume and it schildren
## [children_to_ignore]: In case we want to avoid resuming a node from the root_node chain. It should be the path
##
static func resume_scene(root_node : Node, children_to_ignore : Array[String] = []):
	_pause_scene_implementation(root_node, false, children_to_ignore)
	
## Pause the entire given scene node. This means pausing the root node and its children
## [node]: Root node to resume and it schildren
## [children_to_ignore]: In case we want to avoid pausing a node from the root_node chain. It should be the path
##
static func pause_scene(root_node : Node, children_to_ignore : Array[String] = []):
	_pause_scene_implementation(root_node, true, children_to_ignore)

#==============================================================================
# PRIVATE FUNCTIONS
#==============================================================================

## Set the pause status of the given node
## [node]: Node to pause
## [pause]: true == pause
##
static func _pause_node_implementation(node : Node, pause : bool) -> void:
	node.set_process(!pause)
	node.set_physics_process(!pause)
	node.set_process_input(!pause)
	node.set_process_internal(!pause)
	node.set_process_unhandled_input(!pause)
	node.set_process_unhandled_key_input(!pause)
	
## Set the pause status of the entire given scene node. This means pausing the root node and its children
## [node]: Root node to pause and it schildren
## [pause]: true == pause
## [children_to_ignore]: In case we want to avoid un/pausing a node from the root_node chain. It should be the path
##
static func _pause_scene_implementation(root_node : Node, pause : bool, children_to_ignore : Array[String] = []):
	_pause_node_implementation(root_node, pause)
	for node in root_node.get_children():
		if not (String(node.get_path()) in children_to_ignore):
			_pause_scene_implementation(node, pause, children_to_ignore)

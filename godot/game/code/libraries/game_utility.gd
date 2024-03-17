## Library that provides utility functions for the game such as pausing, screen,node dimensions and so on.
##
class_name GameUtilityLibrary

#==============================================================================
# VARIABLES
#==============================================================================

## Global width and height to use in case we want to know the screen dimensions.
##
static var SCREEN_WIDTH = ProjectSettings.get_setting("display/window/size/viewport_width")
static var SCREEN_HEIGHT = ProjectSettings.get_setting("display/window/size/viewport_height")

static var SCREEN_WIDTH_PLAY_ZONE : Vector2 = Vector2(0.,0.)
static var SCREEN_HEIGHT_PLAY_ZONE : Vector2 = Vector2(0.,0.)

#==============================================================================
# PUBLIC FUNCTIONS
#==============================================================================

## Loop through all the children checking for the class_type given as a paremeter.
## Check against the name and the get class
## [root_node]: Base node to loop through the children
## [class_type]: Class to look up for. E.g (Sprite2D, TextureRect...)
##
static func get_child_node_by_class_or_name(root_node : Node, class_type : String):
	if root_node.name == class_type or root_node.get_class() == class_type: return root_node
	for node_child in root_node.get_children():
		if node_child.name == class_type or node_child.get_class() == class_type: return node_child
		if node_child.get_child_count() > 0:
			var inner_child = get_child_node_by_class_or_name(node_child, class_type)
			if inner_child != null : return inner_child
	
	return null

## Get the actual width of a node that contains a sprite or a texture rect as a child
## NOTE!: The function takes into account the node scale, not the texture rect or sprite scale!
##
static func get_node_actual_width(node : Node) -> float:
	var sprite = get_child_node_by_class_or_name(node, "Sprite2D")
	if sprite:
		return sprite.texture.get_width() * node.scale.x
		
	var texture_rect = get_child_node_by_class_or_name(node, "TextureRect")
	if texture_rect != null:
		return texture_rect.size.x * node.scale.x

	assert(texture_rect, "Trying to get the width from a node that doesn't have a Sprite2D or TextureRect")
	return 0.0

## Get the actual height of a node that contains a sprite or a texture rect as a child
## NOTE!: The function takes into account the node scale, not the texture rect or sprite scale!
##	
static func get_node_actual_height(node : Node) -> float:
	var sprite = get_child_node_by_class_or_name(node, "Sprite2D")
	if sprite:
		return sprite.texture.get_height() * node.scale.y
		
	var texture_rect = get_child_node_by_class_or_name(node, "TextureRect")
	if texture_rect:
		return texture_rect.size.y * node.scale.y

	assert(texture_rect, "Trying to get the width from a node that doesn't have a Sprite2D or TextureRect")
	return 0.0

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
	
##
##
static func remove_children(node : Node) -> void:
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()
		
## Returns the given text centered
##
static func get_centered_text(text : String) -> String:
	return "[center]" + text + "[/center]"

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
	if node is RigidBody2D :
		node.freeze = true

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

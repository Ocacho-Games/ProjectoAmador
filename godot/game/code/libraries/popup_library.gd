## Library for providing useful popup creation and so on
class_name PopupLibrary

#==============================================================================
# VARIABLES
#==============================================================================

## References to preload pop up scenes in order to instanciate them
static var INFO_POPUP_SCENE = preload("res://game/scenes/menu/info_popup.tscn")
static var SHOP_POPUP_SCENE = preload("res://game/scenes/menu/shop/shop_popup.tscn")

#==============================================================================
# FUNCTIONS
#==============================================================================

## Show an info popup and stop the game until you close the popup
## [root_for_child_node]: Node to add the popup as child
## [text]: Text to show in the info popup
## [on_popup_closed]: Optional popup to call when the popup is closed
##
static func show_info_popup(root_for_child_node : Node, text : String, on_popup_closed : Callable = Callable()) -> void:
	GameUtilityLibrary.pause_scene(root_for_child_node)
	var popup_node = INFO_POPUP_SCENE.instantiate() as InfoPopup
	popup_node.set_properties(text, on_popup_closed)
	root_for_child_node.add_child(popup_node)

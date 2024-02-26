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
## [close_visible]: Whether the close button of the popup is visible or not
## [on_popup_closed]: Optional popup to call when the popup is closed
##
static func show_info_popup(root_for_child_node : Node, text : String, close_visible : bool = true, on_popup_closed : Callable = Callable()) -> InfoPopup:
	assert(INFO_POPUP_SCENE, "Not valid Info popup scene")	 
	GameUtilityLibrary.pause_scene(root_for_child_node.get_tree().root)
	var popup_node = INFO_POPUP_SCENE.instantiate() as InfoPopup
	popup_node.set_properties(text, on_popup_closed, close_visible)
	root_for_child_node.add_child(popup_node)
	return popup_node

## Show an info popup and stop the game until you close the popup
## [root_for_child_node]: Node to add the popup as child
## [collectable]: Reference to the collectable to extract the information from
##
static func show_shop_popup(root_for_child_node : Node, collectable : SCollectable) -> void:
	assert(SHOP_POPUP_SCENE, "Not valid Shop popup scene")
	var popup_node = SHOP_POPUP_SCENE.instantiate() as ShopPopup
	popup_node.set_properties(collectable)
	root_for_child_node.add_child(popup_node)
	

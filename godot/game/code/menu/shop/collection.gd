## Actual script of the collectable node. This will be the node that is spawned on the shop
##
class_name CollectionNode extends Node

#==============================================================================
# VARIABLES
#==============================================================================

## Cached value of the collection's key
var cached_collection_key : String
## Cached reference to the shop node
var cached_shop_node : ShopNode

#==============================================================================
# PUBLIC FUNCTIONS
#==============================================================================

##
##
func set_collection_properties(collection : SCollection, shop_node : ShopNode):
	get_node("sprite").set_texture_normal(collection.shop_sprite)
	cached_collection_key = collection.key
	cached_shop_node = shop_node

##
##
func set_selected_visibility(active : bool):
	get_node("sprite/selected").visible = active	

#==============================================================================
# PRIVATE FUNCTIONS
#==============================================================================

#==============================================================================
# SIGNAL FUNCTIONS
#==============================================================================

## Every collectable is/has a button attached to it. Signal when pressed 
##		
func _on_texture_button_pressed():
	cached_shop_node.display_collection(cached_collection_key)

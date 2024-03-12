## This component is in charge of select the right collectable for the parent node based on the given collection
##
class_name SelectCollectableCmp extends Node

#==============================================================================
# VARIABLES
#==============================================================================

## Collection key to look up for the collectable
@export var collection : SCollection

## Type of collectable you are looking for changing. Depending on this you will change the Texture, an AudioStream... of the parent
@export var type_of_collectable : SCollectable.ECollectableType

#==============================================================================
# GODOT FUNCTIONS
#==============================================================================

# Called when the node enters the scene tree for the first time.
func _ready():
	set_name.call_deferred("SelectCollectableCmp")
	if(collection):
		_set_asset_by_collectable_type()

#==============================================================================
# PRIVATE FUNCTIONS
#==============================================================================

## Depeding on the collectable's type. Change a different property of the parent
## Ex: Sprite = parent.texture
##
func _set_asset_by_collectable_type() -> void:
	var asset = _get_collectable_asset()
	if not asset : return
	
	match type_of_collectable:
		SCollectable.ECollectableType.SPRITE:
			get_parent().texture = asset 	

## Based on the provided collection and the type of collectable,
## Look on the cloud data for the current selected asset of the user
##
func _get_collectable_asset() -> Resource:
	var save_key = "current_" + collection.get_string_key() + "_" + SCollectable.ECollectableType.keys()[type_of_collectable]
	save_key = save_key.to_lower()
	var collectable_name = SGPS.get_saved_data(save_key, "")
	
	for in_collectable in collection.collectables:
		if collectable_name == in_collectable.key:
			return in_collectable.asset
	
	return null

	
	

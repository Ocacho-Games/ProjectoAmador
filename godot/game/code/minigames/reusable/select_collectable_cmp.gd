## This component is in charge of select the right collectable for the parent node based on the given collection
##
class_name SelectCollectableCmp extends Node

# TODO: Do we need to create an array of collection?

## Collection key to look up for the collectable
@export var collection : SCollection

# Called when the node enters the scene tree for the first time.
func _ready():
	set_name.call_deferred("SelectCollectableCmp")
	get_parent().get_node("Sprite2D").texture = _get_collectable_asset()	

func _get_collectable_asset() -> Resource:
	var save_key = "current_" + collection.key
	var collectable_name = SGPS.data_to_save.dictionary[save_key]
	
	for in_collectable in collection.collectables:
		if collectable_name == in_collectable.key:
			return in_collectable.asset
	
	return null

## This component is in charge of select the right collectable for the parent node based on the given collection
##
class_name SelectCollectableCmp extends Node

## Collection key to look up for the collectable
@export var collection : SCollection

@export var type_of_collectable : SCollectable.ECollectableType

# Called when the node enters the scene tree for the first time.
func _ready():
	set_name.call_deferred("SelectCollectableCmp")
	_set_collectable_by_type()

func _set_collectable_by_type() -> void:
	var asset = _get_collectable_asset()
	if not asset : return
	
	match type_of_collectable:
		SCollectable.ECollectableType.SPRITE:
			get_parent().texture = asset 	

func _get_collectable_asset() -> Resource:
	var save_key = "current_" + collection.key + "_" + SCollectable.ECollectableType.keys()[type_of_collectable]
	save_key = save_key.to_lower()
	var collectable_name = SGPS.data_to_save.dictionary[save_key]
	
	for in_collectable in collection.collectables:
		if collectable_name == in_collectable.key:
			return in_collectable.asset
	
	return null

	
	

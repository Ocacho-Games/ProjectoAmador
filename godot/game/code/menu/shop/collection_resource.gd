class_name SCollection extends Resource

## Name that will be displayed in the store. NOTE: This should be translated when localiziting
@export var shop_name = "BOB"

## Unique ID name of the collecction. There should be an array entry on save_data with the same name
@export var key : String = "test-key-skin"

## Array containing the collectables that take part of this collection
@export var collectables : Array[SCollectable]

## TODO
##
func add_callable_to_objetive_collectable(callable : Callable, collectable_key : String) -> bool:
	if not callable: return false
	for collectable in collectables:
		if collectable.key == collectable_key and collectable.unlock_type == SCollectable.EUnlockType.OBJETIVE:
			collectable.objetive_callable = callable
			return true
	
	assert(false, "Trying to add a callable to an invalid collectable key")
	return false
	

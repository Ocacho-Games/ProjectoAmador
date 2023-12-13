## A collection in Suipe is a bunch of related collectables. 
## For example we can have a collection for bob, another one for the spaceship game etc...
## These collections will be used for describing our collectable skins, sounds etc...
##
class_name SCollection extends Resource

#==============================================================================
# VARIABLES
#==============================================================================

## Name that will be displayed in the store. NOTE: This should be translated when localiziting
@export var shop_name = "BOB"

## Unique ID name of the collecction. There should be an array entry on save_data with the same name
@export var key : String = "test-key-skin"

## Array containing the collectables that take part of this collection
@export var collectables : Array[SCollectable]

#==============================================================================
# HELPER FUNCTIONS
#==============================================================================

## Some collectables that are set as objetive need callables in order to check if they are unlock or not.
## This is a helper function to bind the callable to an specific collectable
## This function will look for a collectable inside this collection in ordere to bind the callable. !Assertions will be raised if not found
## [callable]: Callable you want to bind to the collectable's callable
## [collectable_key]: Specific collectable's key in order to find the collectable.
##
func add_callable_to_objetive_collectable(callable : Callable, collectable_key : String) -> bool:
	if not callable: return false
	for collectable in collectables:
		if collectable.key == collectable_key and collectable.unlock_type == SCollectable.EUnlockType.OBJETIVE:
			collectable.objetive_callable = callable
			return true
	
	assert(false, "Trying to add a callable to an invalid collectable key")
	return false
	

## Resource containing the data necessary to describe a collectable (skin, sound...) 
##
class_name SCollectable extends Resource

#==============================================================================
# TYPES
#==============================================================================

## Type of the collectable
enum ECollectableType {SPRITE}

## How to unblock the collectable
enum EUnlockType { COINS, VIDEO, OBJETIVE}

#==============================================================================
# VARIABLES
#==============================================================================

## The unique key that identifies this collectable
@export var key : String = "test-key-skin"

## Which type of collectable is. See ECollectableType
@export var type : ECollectableType

## Define how we want to unlock this collectable. 
## You will find additional properties on the "Unlock conditions" section
@export var unlock_type : EUnlockType

@export_group("Unlock conditions")
## In case unlock_type is set to COINS, how many coins do we need to unlock this collectable
@export var coins_to_unlock : int = 200
## In case unlock_type is set to VIDEO, how many videos do we need to watch in order to unlock this collectable
@export var videos_to_unlock : int = 4
## In case unlock_type is set to OBJETIVE, the description that should appear if the collectable is unlocked
@export var objetive_description : String = "?"
## In case unlock_type is set to OBJETIVE, the boolean function that should be called to check if the collectable is unlocked. 
## This should be bound in load_collectable_callbacks() (Minigame.gd) or children
@export var objetive_callable : Callable
@export_group("")

## This is the sprite that will be displayed as the box recovering the asset sprites
@export var box_sprite : Texture2D

## This is the sprite that will be displayed on the shop if unlock, not the actual resource.
@export var shop_sprite : Texture

## This should be the sprite that is shown when the collectable is lock
@export var lock_shop_sprite : Texture

# Actual asset to load if unlocked
@export var asset : Resource

#==============================================================================
# HELPER FUNCTIONS
#==============================================================================

## Parse the ECollectableType enum to string. Used for saving the cloud data automatically
##
func get_type_to_string() -> String:
	if type == ECollectableType.SPRITE: return "sprite"

	return ""

class_name SCollectable extends Resource


var test_dropdwon : Array[String] = ["Jose", "Maria"]

## Type of the collectable
enum ECollectableType {SPRITE, SOUND}

## How to unblock the collectable
enum EUnlockType { COINS, VIDEO, OBJETIVE}

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
@export_group("")

## This is the sprite that will be displayed on the shop, not the actual resource.
@export var shop_sprite : Texture

## This should be the sprite that is shown when the collectable is blocked
@export var blocked_shop_sprite : Texture

# Actual asset to load if unlocked
@export var asset : Resource

## Parse the ECollectableType enum to string
##
func get_type_to_string() -> String:
	if type == ECollectableType.SPRITE: return "sprite"
	if type == ECollectableType.SOUND: return "sound"

	return ""

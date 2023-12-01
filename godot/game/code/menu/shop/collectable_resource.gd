class_name SCollectable extends Resource

## Type of the collectable
enum ECollectableType {SPRITE, SOUND}

## How to unblock the collectable
enum EUnlockType { COINS, VIDEO}

@export var key : String = "test-key-skin"

@export var type : ECollectableType

@export var unlock_type : EUnlockType
@export_group("Unlock conditions")
@export var coins_to_unlock : int = 200
@export_group("")

#This is the sprite that will be displayed on the shop, not the actual resource.
@export var shop_sprite : Texture

#This should be the sprite that is shown when the collectable is blocked
@export var blocked_shop_sprite : Texture

#This should be the sprite or similar
@export var asset : Resource


func get_type_to_string() -> String:
	if type == ECollectableType.SPRITE: return "sprite"
	if type == ECollectableType.SOUND: return "sound"	

	return ""

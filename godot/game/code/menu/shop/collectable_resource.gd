class_name SCollectable extends Resource

## Type of the collecatbale
enum ECollectableType {SPRITE, SOUND}

@export var key : String = "test-key-skin"

@export var type : ECollectableType

#This is the sprite that will be displayed on the shop, not the actual resource.
@export var shop_sprite : Texture

#This should be the sprite that is shown when the collectable is blocked
@export var blocked_shop_sprite : Texture

#This should be the sprite or similar
@export var asset : Resource

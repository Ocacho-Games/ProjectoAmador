class_name SCollectable extends Resource

## Type of the collecatbale
enum ECollectableType {SPRITE, SOUND}

@export var key : String = "test-key-skin"

@export var type : ECollectableType

#This should be the sprite or similar
@export var asset : Resource

# Am I gonna use this?
@export var should_unlock_with_video : bool = false

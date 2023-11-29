class_name SCollection extends Resource

@export var key : String = "test-key-skin"

#This should be the sprite that is shown when the collectable is blocked
@export var blocked_sprite : Resource

## Array containing the definition of our minigames
@export var collectables : Array[SCollectable]

extends Node

@export var skins : Array[SCollection]

@onready var type_store_text : RichTextLabel = $Control/RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	type_store_text.text = "BOB"
	
	var initial_x = 300
	var initial_y = 600
	
	for skin in skins:
		for collectable in skin.collectables:
			var sprite = Sprite2D.new()
			
			if _is_collectable_blocked(skin.key, collectable.key):
				sprite.texture = collectable.asset				
			else:
				sprite.texture = skin.blocked_sprite				
				
			sprite.position.x = initial_x
			sprite.position.y = initial_y
			sprite.scale = Vector2(0.6, 0.6)			

			call_deferred("add_child", sprite)
			initial_x += 300

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_left_pressed():
	pass # Replace with function body.


func _on_right_pressed():
	pass # Replace with function body.

func _is_collectable_blocked(collection_key : String, collectable_key : String) -> bool:
	for collectable_name in SGPS.data_to_save.dictionary[collection_key]:
		if collectable_name == collectable_key:
			return true
	return false
	

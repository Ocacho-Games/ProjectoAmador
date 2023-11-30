extends Node

@export var collections : Array[SCollection]

@onready var type_store_text : RichTextLabel = $Control/RichTextLabel
@onready var skin_container : HBoxContainer = $Control/ScrollContainer/HBoxContainer

var current_index_collection : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	_display_current_collection()
	
func _process(_delta):
	#print(current_index_collection)
	pass

func _on_left_pressed():
	if current_index_collection - 1 >= 0:
		current_index_collection = current_index_collection - 1
		return
		
	current_index_collection = 0
	#_display_current_collection()

func _on_right_pressed():
	if current_index_collection + 1 < collections.size():
		current_index_collection = current_index_collection + 1
		return
		
	current_index_collection = 0
	#_display_current_collection()

func _display_current_collection() -> void:
	var current_collection = collections[current_index_collection]
	type_store_text.text = current_collection.shop_name
	
	## Add section labels like, Skins, sounds etc
	
	var initial_x = 300
	var initial_y = 200
	
	for collectable in current_collection.collectables:
			var sprite = Sprite2D.new()
			
			if _is_collectable_blocked(current_collection.key, collectable.key):
				sprite.texture = collectable.shop_sprite				
			else:
				sprite.texture = collectable.blocked_shop_sprite				
				
			sprite.position.x = initial_x
			sprite.position.y = initial_y
			sprite.scale = Vector2(0.6, 0.6)			

			skin_container.call_deferred("add_child", sprite)
			initial_x += 300
			if initial_x > 1000:
				initial_x = 300
				initial_y += 350
	

func _is_collectable_blocked(collection_key : String, collectable_key : String) -> bool:
	for collectable_name in SGPS.data_to_save.dictionary[collection_key]:
		if collectable_name == collectable_key:
			return true
	return false
	

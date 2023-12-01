extends Node

@export var collections : Array[SCollection]
@export var collectable_scene : PackedScene

@onready var coins_label : RichTextLabel = $Control/coins_label
@onready var type_store_text : RichTextLabel = $Control/type_store_label
@onready var skin_container : HBoxContainer = $Control/ScrollContainer/HBoxContainer

var current_index_collection : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	_display_current_collection()
	
func _process(_delta):
	coins_label.text = "Coins: " + str(SGPS.data_to_save.dictionary["coins"])	

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

func _on_back_to_game_button_pressed():
	SceneManager.change_scene("res://game/scenes/reel.tscn")

func _display_current_collection() -> void:
	var current_collection = collections[current_index_collection]
	type_store_text.text = current_collection.shop_name
	
	## Add section labels like, Skins, sounds etc
	
	var initial_x = 300
	var initial_y = 200
	
	for collectable in current_collection.collectables:
		var collectable_node = collectable_scene.instantiate()
		collectable_node = collectable_node as CollectableNode
		
		collectable_node.set_collectable_properties(current_collection.key, collectable)			
		collectable_node.position.x = initial_x
		collectable_node.position.y = initial_y		

		skin_container.call_deferred("add_child", collectable_node)
		initial_x += 300
		if initial_x > 1000:
			initial_x = 300
			initial_y += 350
	



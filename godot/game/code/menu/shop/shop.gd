extends Node

## This is a draft because we don't know the shop structure yet, so no comments

#==============================================================================
# VARIABLES
#==============================================================================

## The shop will display a bunch of collections, these are the collections to display
@export var collections : Array[SCollection]
## This is the collectable scene to instantiate when displaying the shop
@export var collectable_scene : PackedScene

#@onready var coins_label : RichTextLabel = $Control/coins_label
## Reference to the containers
@onready var coins_container : GridContainer = $base_structure/VBoxContainer/GameZone/BaseTienda/ScrollCollectables/CenterCollectables/CollectablesTypes/CoinsCollectables
@onready var videos_container : GridContainer = $base_structure/VBoxContainer/GameZone/BaseTienda/ScrollCollectables/CenterCollectables/CollectablesTypes/VideosCollectables
@onready var objetive_container : GridContainer = $base_structure/VBoxContainer/GameZone/BaseTienda/ScrollCollectables/CenterCollectables/CollectablesTypes/AchievementsCollectables
@onready var collectable_type_container : HBoxContainer = $base_structure/VBoxContainer/GameZone/BaseTienda/ScrollTypeCollectable/HBoxContainer

var current_index_collection : int = 0

#==============================================================================
# GODOT FUNCTIONS
#==============================================================================

# Called when the node enters the scene tree for the first time.
func _ready():
	_display_current_collection()
	# TODO. The collection type node similar to collectable
	# menu container sizing logic
	#_add_collections_to_container()
	
func _process(_delta):
	pass
	#coins_label.text = "Coins: " + str(SGPS.data_to_save_dic["coins"])	

#==============================================================================
# PRIVATE FUNCTIONS
#==============================================================================

func _display_current_collection() -> void:
	var current_collection = collections[current_index_collection]

	
	for collectable in current_collection.collectables:
		var collectable_node = collectable_scene.instantiate()
		collectable_node = collectable_node as CollectableNode
		
		collectable_node.set_collectable_properties(current_collection.key, collectable)			

		var selected_container
		if collectable.unlock_type == SCollectable.EUnlockType.COINS: selected_container = coins_container
		elif collectable.unlock_type == SCollectable.EUnlockType.VIDEO: selected_container = videos_container
		elif collectable.unlock_type == SCollectable.EUnlockType.OBJETIVE: selected_container = objetive_container
		
		selected_container.call_deferred("add_child", collectable_node)

#==============================================================================
# SIGNAL FUNCTIONS
#==============================================================================

#func _on_left_pressed():
#	if current_index_collection - 1 >= 0:
#		current_index_collection = current_index_collection - 1
#		return
#
#	current_index_collection = 0
#	#_display_current_collection()
#
#func _on_right_pressed():
#	if current_index_collection + 1 < collections.size():
#		current_index_collection = current_index_collection + 1
#		return
#
#	current_index_collection = 0
#	#_display_current_collection()

func _on_video_coin_button_pressed():
	# Show pop up as loading the video maybe on the library
	get_tree().get_root().set_disable_input(true)
	var ad : RewardedAd
	var ad_listener = OnUserEarnedRewardListener.new()
	ad_listener.on_user_earned_reward = func(_rewarded_item):
		SGPS.data_to_save_dic["coins"] += 25
		get_tree().get_root().set_disable_input(false)
		ad.destroy()
	
	ad = AdsLibrary.load_show_rewarded(ad_listener)

func _on_back_to_game_button_pressed():
	SceneManager.change_scene("res://game/scenes/reel.tscn")

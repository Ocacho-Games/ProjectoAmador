class_name ShopNode extends Node

## This is a draft because we don't know the shop structure yet, so no comments

#==============================================================================
# VARIABLES
#==============================================================================

## This is the collectable scene to instantiate when displaying the shop
@export var collectable_scene : PackedScene
## TODO
@export var collection_scene : PackedScene

#@onready var coins_label : RichTextLabel = $Control/coins_label
## Reference to the containers
@onready var coins_container : GridContainer = $base_structure/VBoxContainer/GameZone/BaseTienda/ScrollCollectables/CenterCollectables/CollectablesTypes/CoinsCollectables
@onready var videos_container : GridContainer = $base_structure/VBoxContainer/GameZone/BaseTienda/ScrollCollectables/CenterCollectables/CollectablesTypes/VideosCollectables
@onready var objetive_container : GridContainer = $base_structure/VBoxContainer/GameZone/BaseTienda/ScrollCollectables/CenterCollectables/CollectablesTypes/AchievementsCollectables
@onready var collection_type_container : HBoxContainer = $base_structure/VBoxContainer/GameZone/BaseTienda/ScrollTypeCollectable/HBoxContainer

var current_index_collection : int = 0
var current_key_collection : String
var collection_nodes_array : Array[CollectionNode]

#==============================================================================
# GODOT FUNCTIONS
#==============================================================================

# Called when the node enters the scene tree for the first time.
func _ready():
	_display_collection_types()
	display_collection(SGame.collections[current_index_collection].key)

#==============================================================================
# PUBLIC FUNCTIONS
#==============================================================================

func display_collection(collection_key : String) -> void:
	var current_collection 
	for collection in SGame.collections:
		if collection.key == collection_key: current_collection = collection
		else: pass
	
	assert(current_collection, "Invalid collection, key not valid or not existent collection")
	
	if current_key_collection == collection_key: return
	else: current_key_collection = collection_key
	
	_set_collection_nodes_visibility()
	
	GameUtilityLibrary.remove_children(coins_container)
	GameUtilityLibrary.remove_children(videos_container)
	GameUtilityLibrary.remove_children(objetive_container)	
	
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
# PRIVATE
#==============================================================================

##
##
func _display_collection_types() -> void:
	for collection in SGame.collections:
		var collection_node = collection_scene.instantiate() as CollectionNode
		collection_node.set_collection_properties(collection, self)				
		collection_nodes_array.append(collection_node)
		collection_type_container.call_deferred("add_child", collection_node)
		
##
##
func _set_collection_nodes_visibility():
	for collection in collection_nodes_array:
		if collection.cached_collection_key == current_key_collection:
			collection.set_selected_visibility(true)
		else:
			collection.set_selected_visibility(false)	

#==============================================================================
# SIGNAL FUNCTIONS
#==============================================================================

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

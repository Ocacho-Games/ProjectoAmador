class_name ShopNode extends Node

## This is a draft because we don't know the shop structure yet, so no comments

#==============================================================================
# VARIABLES
#==============================================================================

## This is the collectable scene to instantiate when displaying the shop
@export var collectable_scene : PackedScene
## This is the coolection scene to instantiate when displaying the types of collections
@export var collection_scene : PackedScene

#@onready var coins_label : RichTextLabel = $Control/coins_label
## Reference to the containers
@onready var coins_container : GridContainer = $base_structure/VBoxContainer/GameZone/BaseTienda/ScrollCollectables/CenterCollectables/CollectablesTypes/CoinsCollectables
@onready var videos_container : GridContainer = $base_structure/VBoxContainer/GameZone/BaseTienda/ScrollCollectables/CenterCollectables/CollectablesTypes/VideosCollectables
@onready var objetive_container : GridContainer = $base_structure/VBoxContainer/GameZone/BaseTienda/ScrollCollectables/CenterCollectables/CollectablesTypes/AchievementsCollectables
@onready var collection_type_container : HBoxContainer = $base_structure/VBoxContainer/GameZone/BaseTienda/ScrollTypeCollectable/HBoxContainer
@onready var coins_video_text : RichTextLabel = $base_structure/VBoxContainer/GameZone/BaseTienda/CollectableTopPart/HBoxContainer2/VideoButton/ObjectiveText

@onready var game_zone : Control = $base_structure/VBoxContainer/GameZone
@onready var gambling_part : BoxContainer = $base_structure/VBoxContainer/GameZone/BaseTienda/CollectableTopPart
@onready var collectable_part : ScrollContainer = $base_structure/VBoxContainer/GameZone/BaseTienda/ScrollCollectables
@onready var collection_part : ScrollContainer = $base_structure/VBoxContainer/GameZone/BaseTienda/ScrollTypeCollectable

var coins_per_video = 20
var current_index_collection : int = 0
var current_key_collection : SCollection.ECollectionNames
var collection_nodes_array : Array[CollectionNode]

#==============================================================================
# GODOT FUNCTIONS
#==============================================================================

# Called when the node enters the scene tree for the first time.
func _ready():
	_prepare_containers()
	_display_collection_types()
	display_collection(SGame.collections[current_index_collection].key, false)
	coins_video_text.text = "[center]+" + str(coins_per_video) + "[/center]"	
	
#==============================================================================
# PUBLIC FUNCTIONS
#==============================================================================

func display_collection(collection_key : SCollection.ECollectionNames, check_for_previous : bool = true) -> void:
	var current_collection 
	for collection in SGame.collections:
		if collection.key == collection_key: current_collection = collection
		else: pass
	
	assert(current_collection, "Invalid collection, key not valid or not existent collection")
	
	if current_key_collection == collection_key and check_for_previous: return
	else: current_key_collection = collection_key
	
	_set_collection_nodes_visibility()
	
	GameUtilityLibrary.remove_children(coins_container)
	GameUtilityLibrary.remove_children(videos_container)
	GameUtilityLibrary.remove_children(objetive_container)	
	
	for collectable in current_collection.collectables:
		var collectable_node = collectable_scene.instantiate()
		collectable_node = collectable_node as CollectableNode
		
		collectable_node.set_collectable_properties(current_collection.get_string_key(), collectable)			

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
func _prepare_containers() -> void:
	var game_zone_percentage = game_zone.custom_minimum_size.y / GameUtilityLibrary.SCREEN_HEIGHT
	
	var percentage_collection = 0.1 * game_zone_percentage 
	collection_part.custom_minimum_size.y = percentage_collection * GameUtilityLibrary.SCREEN_HEIGHT
##
##
func _display_collection_types() -> void:
	for collection in SGame.collections:
		var collection_node = collection_scene.instantiate() as CollectionNode
		collection_node.set_collection_properties(collection, self)
		collection_node.custom_minimum_size.x = collection_part.custom_minimum_size.y			
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
	var ad : RewardedAd
	var ad_listener = OnUserEarnedRewardListener.new()
	ad_listener.on_user_earned_reward = func(_rewarded_item):
		SGPS.data_to_save_dic["coins"] += 25
		if(ad):	ad.destroy()
	
	ad = AdsLibrary.load_show_rewarded(self, ad_listener)

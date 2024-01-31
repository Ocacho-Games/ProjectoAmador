## Actual script of the collectable node. This will be the node that is spawned on the shop
##
class_name CollectableNode extends Node

#==============================================================================
# VARIABLES
#==============================================================================

@export var coin_texture: Texture2D
@export var objetive_texture: Texture2D
@export var video_texture: Texture2D
@export var selected_texture : Texture2D
@export var lock_sprite_texture : Texture2D
@export var lock_box_texture: Texture2D

## Reference to the pop up in case this is an objetive collectable
@onready var pop_up : Window = $pop_up

## Cached value of the lock status of the collectable
var cached_is_lock : bool
## Cached value of the collection's key
var cached_collection_key : String
## Cached value of the collectable itself
var cached_collectable : SCollectable
## Cached corner Sprite2D info node
var cached_sprite_corner_info : Sprite2D
## Cached corner Text info nod
var cached_text_corner_info : RichTextLabel

#==============================================================================
# GODOT FUNCTIONS
#==============================================================================

# Called when the node enters the scene tree for the first time.
func _ready():
	pop_up.hide()

# Called each frame
func _process(_delta):
	_check_selected_collectable()

#==============================================================================
# PUBLIC FUNCTIONS
#==============================================================================

## Store and set the properties of the collectable based on the block status of it.
## This should be called when instanciating a new collectable node, passing the necesary arguments. Ex: Called from the shop.gd
## [collection_key]: Collection unique ID name this collectioin belongs to
## [collectable]: Collectable resource containing the data to set to this node
##
func set_collectable_properties(collection_key : String, collectable : SCollectable):
	cached_collectable = collectable
	cached_collection_key = collection_key
	
	cached_is_lock = _is_collectable_lock()
	_check_objetive_collectable()	
	
	get_node("BoxButton").set_texture_normal(collectable.box_sprite)
	
	var sprite_asset : Sprite2D = get_node("BoxButton/asset")
	cached_sprite_corner_info = get_node("BoxButton/corner_info")
	cached_text_corner_info = cached_sprite_corner_info.get_node("corner_info_text") 	
	
	if cached_is_lock: _set_lock_collectable_properties(sprite_asset)
	else: sprite_asset.texture = collectable.shop_sprite

#==============================================================================
# PRIVATE FUNCTIONS
#==============================================================================

## Check and return if this collectable is lock a.k.a the user doesn't have it.
## The collectable is lock if the user doesn't have it on the cloud data related to the collectable's collection
##
func _is_collectable_lock() -> bool:
	for collectable_name in SGPS.data_to_save_dic[cached_collection_key]:
		if collectable_name == cached_collectable.key:
			return false
			
	return true

## In case the collectable is lock and it is a objetive collectable,
## We should check if the user has accomplished the objetive in order to unlock the collectable
##
func _check_objetive_collectable() -> void:
	if cached_is_lock == false: return
	if cached_collectable.unlock_type != SCollectable.EUnlockType.OBJETIVE: return
	
	assert(cached_collectable.objetive_callable.is_valid(), "Trying to call a null callable in a objetive collectable")
	
	#TODO: I would like to measure this function
	var objetive_callable_result = cached_collectable.objetive_callable.call() 
	var progress_bar : ProgressBar = GameUtilityLibrary.get_child_node_by_class(self, "ProgressBar") 
	progress_bar.visible = true
	progress_bar.value = objetive_callable_result[1]
	
	if objetive_callable_result[0]:
		cached_is_lock = false
		SGPS.data_to_save_dic[cached_collection_key].append(cached_collectable.key)
		SGPS.save_game()
		
## In case the collectable in unlock. Must be called each frame
## We should check if the collectable is the selected one in order to change the select mark
##
func _check_selected_collectable() -> void:
	if cached_is_lock: return
	
	var name_selected_asset : String = "current_" + cached_collection_key + "_" + cached_collectable.get_type_to_string()	
	if cached_collectable.key == SGPS.get_saved_data(name_selected_asset):
		cached_sprite_corner_info.texture = selected_texture
		cached_sprite_corner_info.visible = true
		cached_text_corner_info.visible = false		 
	else:
		cached_sprite_corner_info.visible = false
		
## In case the collectable is lock set the properties of it based on the unlock type
## [sprite]: Reference to the shop sprite to change
## [sprite_corner_info]: Reference to the sprite that shows the type of asset in order to change it
##
func _set_lock_collectable_properties(sprite : Sprite2D) -> void:
	sprite.texture = lock_sprite_texture
	get_node("BoxButton").set_texture_normal(lock_box_texture)	
	match cached_collectable.unlock_type:
		SCollectable.EUnlockType.COINS:
			cached_sprite_corner_info.texture = coin_texture
			cached_text_corner_info.text = str(cached_collectable.coins_to_unlock)			
		SCollectable.EUnlockType.VIDEO:
			var remaining_videos_key : String = "remaining_" + cached_collectable.key + "_videos"
			var remaining_videos = SGPS.get_saved_data(remaining_videos_key, cached_collectable.videos_to_unlock)
			cached_sprite_corner_info.texture = video_texture
			cached_text_corner_info.text = "x" + str(remaining_videos)
		SCollectable.EUnlockType.OBJETIVE:
			cached_sprite_corner_info.texture = objetive_texture
			cached_text_corner_info.visible = false
			sprite.texture = cached_collectable.shop_sprite
			sprite.set_modulate(Color(1, 1, 1, 0.1))

## Called when the button is pressed and the collectable is lock
## Depending on the unlock_type of the collectable, check if we can unlock it or not. 
## If so, we unlock it and save it to the collection's array of the cloud data 
##		
func _button_pressed_lock() -> void:
	match cached_collectable.unlock_type:
		
		SCollectable.EUnlockType.COINS:
			var current_coins = SGPS.data_to_save_dic["coins"]
			if current_coins >= cached_collectable.coins_to_unlock:
				SGPS.data_to_save_dic[cached_collection_key].append(cached_collectable.key)
				SGPS.data_to_save_dic["coins"] = current_coins - cached_collectable.coins_to_unlock
				set_collectable_properties(cached_collection_key, cached_collectable)
				
		SCollectable.EUnlockType.VIDEO:
			get_tree().get_root().set_disable_input(true)
			var ad : RewardedAd
			var ad_listener = OnUserEarnedRewardListener.new()
			ad_listener.on_user_earned_reward = func(_rewarded_item):
				var remaining_videos_key : String = "remaining_" + cached_collectable.key + "_videos"
				var remaining_videos = SGPS.get_saved_data(remaining_videos_key, cached_collectable.videos_to_unlock)
				
				if remaining_videos == 1:
					SGPS.data_to_save_dic[cached_collection_key].append(cached_collectable.key)
				else:
					SGPS.data_to_save_dic[remaining_videos_key] = remaining_videos - 1
				
				set_collectable_properties(cached_collection_key, cached_collectable)					
				get_tree().get_root().set_disable_input(false)
				ad.destroy()
			
			ad = AdsLibrary.load_show_rewarded(ad_listener)
			
		SCollectable.EUnlockType.OBJETIVE:
			pop_up.show()
			pop_up.get_node("RichTextLabel").text = cached_collectable.objetive_description

## Called when the button is pressed and the collectable is unlock
## Change the current asset for the collectable's type in the cloud data
##	
func _button_pressed_unlock() -> void:
	var key = "current_" + cached_collection_key + "_" + cached_collectable.get_type_to_string()
	SGPS.data_to_save_dic[key] = cached_collectable.key
	set_collectable_properties(cached_collection_key, cached_collectable)			

#==============================================================================
# SIGNAL FUNCTIONS
#==============================================================================

## Every collectable is/has a button attached to it. Signal when pressed 
##		
func _on_box_button_pressed():
	if cached_is_lock: _button_pressed_lock()
	else: _button_pressed_unlock()
		
	SGPS.save_game()	

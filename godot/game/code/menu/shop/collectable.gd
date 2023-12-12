## Actual script of the collectable node. This will be the node that is spawned on the shop
##
class_name CollectableNode extends Node

#==============================================================================
# VARIABLES
#==============================================================================

## Reference to the pop up in case this is an objetive collectable
@onready var pop_up : Window = $pop_up 

## Cached value of the lock status of the collectable
var cached_is_lock : bool
## Cached value of the collection's key
var cached_collection_key : String
## Cached value of the collectable itself
var cached_collectable : SCollectable

#==============================================================================
# GODOT FUNCTIONS
#==============================================================================

# Called when the node enters the scene tree for the first time.
func _ready():
	pop_up.hide()

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
	
	var sprite : Sprite2D = get_node("Sprite2D")
	var button : Button = sprite.get_node("Button")
	
	if cached_is_lock:
		_set_lock_collectable_properties(sprite, button)
	else:
		sprite.texture = collectable.shop_sprite
		button.text = "Select"					

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
	
	if cached_collectable.objetive_callable.call():
		cached_is_lock = false
		SGPS.data_to_save_dic[cached_collection_key].append(cached_collectable.key)
		SGPS.save_game()
		
## In case the collectable is lock set the properties of it based on the unlock type
## [sprite]: Reference to the shop sprite to change
## [button]: Reference to the shop button to change
##
func _set_lock_collectable_properties(sprite : Sprite2D, button : Button) -> void:
	sprite.texture = cached_collectable.lock_shop_sprite
	match cached_collectable.unlock_type:
		SCollectable.EUnlockType.COINS:
			button.text = "Unlock " + str(cached_collectable.coins_to_unlock) + " coins"
		SCollectable.EUnlockType.VIDEO:
			button.text = "Watch a video to unlock"
		SCollectable.EUnlockType.OBJETIVE:
			button.text = "See the objetive pop-up"

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
			#TODO: We have to disable input when loading and only ad coins when watiching the full video
			var _ad = AdsLibrary.load_show_rewarded()
		SCollectable.EUnlockType.OBJETIVE:
			pop_up.show()
			pop_up.get_node("RichTextLabel").text = cached_collectable.objetive_description

## Called when the button is pressed and the collectable is unlock
## Change the current asset for the collectable's type in the cloud data
##	
func _button_pressed_unlock() -> void:
	var key = "current_" + cached_collection_key + "_" + cached_collectable.get_type_to_string()
	SGPS.data_to_save_dic[key] = cached_collectable.key			

#==============================================================================
# SIGNAL FUNCTIONS
#==============================================================================

## Every collectable is/has a button attached to it. Signal when pressed 
##		
func _on_button_pressed():
	if cached_is_lock: _button_pressed_lock()
	else: _button_pressed_unlock()
		
	SGPS.save_game()				

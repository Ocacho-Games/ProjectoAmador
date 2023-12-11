class_name CollectableNode extends Node

@onready var pop_up : Window = $pop_up 

var cached_is_blocked : bool
var cached_collection_key : String
var cached_collectable : SCollectable

# Called when the node enters the scene tree for the first time.
func _ready():
	pop_up.hide()

##
##
func set_collectable_properties(collection_key : String, collectable : SCollectable):
	cached_collectable = collectable
	cached_collection_key = collection_key
	
	cached_is_blocked = _is_collectable_blocked()
	_check_objetive_collectable()	
	
	var sprite : Sprite2D = get_node("Sprite2D")
	var button : Button = sprite.get_node("Button")
	
	if cached_is_blocked:
		sprite.texture = collectable.blocked_shop_sprite
		match collectable.unlock_type:
			SCollectable.EUnlockType.COINS:
				button.text = "Unlock " + str(collectable.coins_to_unlock) + " coins"
			SCollectable.EUnlockType.VIDEO:
				button.text = "Watch a video to unlock"
			SCollectable.EUnlockType.OBJETIVE:
				button.text = "See the objetive"
	else:
		sprite.texture = collectable.shop_sprite
		button.text = "Select"					

##
##		
func _on_button_pressed():
	if cached_is_blocked:
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
	else:
		var key = "current_" + cached_collection_key + "_" + cached_collectable.get_type_to_string()
		SGPS.data_to_save_dic[key] = cached_collectable.key
		
	SGPS.save_game()				

##
##
func _check_objetive_collectable() -> void:
	if cached_is_blocked == false: return
	if cached_collectable.unlock_type != SCollectable.EUnlockType.OBJETIVE: return
	
	assert(cached_collectable.objetive_callable.is_valid(), "Trying to call a null callable in a objetive collectable")
	
	if cached_collectable.objetive_callable.call():
		cached_is_blocked = false
		SGPS.data_to_save_dic[cached_collection_key].append(cached_collectable.key)
		SGPS.save_game()				
		
##
##
func _is_collectable_blocked() -> bool:
	for collectable_name in SGPS.data_to_save_dic[cached_collection_key]:
		if collectable_name == cached_collectable.key:
			return false
			
	return true

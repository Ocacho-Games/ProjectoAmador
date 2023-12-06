class_name CollectableNode extends Node

var cached_is_blocked : bool
var cached_collection_key : String
var cached_collectable : SCollectable

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func set_collectable_properties(collection_key : String, collectable : SCollectable):
	cached_collectable = collectable
	cached_collection_key = collection_key
	cached_is_blocked = _is_collectable_blocked(collection_key, collectable.key)
	
	var sprite : Sprite2D = get_node("Sprite2D")
	var button : Button = sprite.get_node("Button")
	
	if cached_is_blocked:
		sprite.texture = collectable.blocked_shop_sprite
		match collectable.unlock_type:
			SCollectable.EUnlockType.COINS:
				button.text = "Unlock " + str(collectable.coins_to_unlock) + " coins"
			SCollectable.EUnlockType.VIDEO:
				button.text = "Watch a video to unlock"				
	else:
		sprite.texture = collectable.shop_sprite
		button.text = "Select"					
		
func _on_button_pressed():
	if cached_is_blocked:
		match cached_collectable.unlock_type:
			SCollectable.EUnlockType.COINS:
				var current_coins = SGPS.data_to_save.dictionary["coins"]
				if current_coins >= cached_collectable.coins_to_unlock:
					SGPS.data_to_save.dictionary[cached_collection_key].append(cached_collectable.key)
					SGPS.data_to_save.dictionary["coins"] = current_coins - cached_collectable.coins_to_unlock
					set_collectable_properties(cached_collection_key, cached_collectable)
			SCollectable.EUnlockType.VIDEO:
				var _ad = AdsLibrary.load_show_rewarded()
	else:
		var key = "current_" + cached_collection_key + "_" + cached_collectable.get_type_to_string()
		SGPS.data_to_save.dictionary[key] = cached_collectable.key
		
	SGPS.save_game()				

func _is_collectable_blocked(collection_key : String, collectable_key : String) -> bool:
	for collectable_name in SGPS.data_to_save.dictionary[collection_key]:
		if collectable_name == collectable_key:
			return false
	return true

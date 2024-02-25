## Popup for showing pure information to the player
class_name ShopPopup extends Node

@onready var center_container = $CenterContainer
@onready var base_popup_control = $CenterContainer/BasePopup

#==============================================================================
# PUBLIC FUNCTIONS
#==============================================================================

func _ready():
	center_container.custom_minimum_size.x = GameUtilityLibrary.SCREEN_WIDTH
	center_container.custom_minimum_size.y = GameUtilityLibrary.SCREEN_HEIGHT * 0.75
	base_popup_control.custom_minimum_size.x = GameUtilityLibrary.SCREEN_WIDTH * 0.8
	

## When instanciating the popup, you can call this function in order to set the popups' properties
##
func set_properties(collectable : SCollectable) -> void:
	GameUtilityLibrary.get_child_node_by_class_or_name(self, "Box").texture = collectable.box_sprite
	GameUtilityLibrary.get_child_node_by_class_or_name(self, "Asset").texture = collectable.shop_sprite	
	GameUtilityLibrary.get_child_node_by_class_or_name(self, "ObjectiveText").text = GameUtilityLibrary.get_centered_text(collectable.objetive_description)
	GameUtilityLibrary.get_child_node_by_class_or_name(self, "ProgressBar").value = collectable.objetive_callable.call()[1]
	GameUtilityLibrary.get_child_node_by_class_or_name(self, "VideoButton").visible = collectable.show_reward_video_button 

#==============================================================================
# SIGNAL FUNCTIONS
#==============================================================================

## Called when the popup is closed clicking on the corner icon
## Resume the scene, calls the callback and destroy the popup
##
func _on_close_pressed():
	queue_free()

## Called when the video button of the popup is pressed
## Reproduce a video and then add the reward to the current score
##
func _on_video_button_pressed():
	get_tree().get_root().set_disable_input(true)
	var _ad : RewardedAd
	var ad_listener = OnUserEarnedRewardListener.new()
	ad_listener.on_user_earned_reward = func(_rewarded_item):
		#TODO: Collectable global +1
		#SGPS.data_to_save_dic["coins"] += 25
		get_tree().get_root().set_disable_input(false)
		_ad.destroy()

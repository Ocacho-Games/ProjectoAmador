## Base structure and logic for the menu of Suipe.
## It is in charge of adjusting the containers and the base strcuture of the ad, game zone and menu.
## This scene should be used in every scene that needs the menu and the ad.
extends Control

## === REFERENCES VARIABLES ===
## Cached banner ad of the minigame in order to destroy it when exiting the mingame
var ad_view

## Reference to the main container of the reel
@onready var main_container : VBoxContainer = $VBoxContainer
## Reference to the main container of the reel
@onready var menu_background : TextureRect = $MenuBackground
## Reference to the middel menu button of the reel
@onready var middle_menu_button = $VBoxContainer/Menu/Middle

#==============================================================================
# GODOT FUNCTIONS
#==============================================================================

# Called when the node enters the scene tree for the first time.
func _ready():
	_prepare_containers()	
	
## Overriden exit tree function
##			
func _exit_tree():	
	if ad_view:
		ad_view.destroy()
		ad_view = null		

#==============================================================================
# PRIVATE FUNCTIONS
#==============================================================================

## In charge of setting the percentages to the different containers in order to be responsive
##
func _prepare_containers() -> void:
	# TODO: Check if the user has bought the ads or not in order to update percentages
	var percentage_menu_background = (GameUtilityLibrary.get_node_actual_height(menu_background)) / GameUtilityLibrary.SCREEN_HEIGHT
	var percentage_ad = 0.085
	var percentage_game = 1.0 - percentage_menu_background - percentage_ad
	
	ad_view = AdsLibrary.load_show_banner(AdSize.new(-1, 50), AdPosition.Values.TOP)	
		
	main_container.size.x = GameUtilityLibrary.SCREEN_WIDTH
	main_container.size.y = GameUtilityLibrary.SCREEN_HEIGHT
	
	var add_min_size = GameUtilityLibrary.SCREEN_HEIGHT * percentage_ad
	var game_min_size = GameUtilityLibrary.SCREEN_HEIGHT * percentage_game
	
	main_container.get_node("Ad").custom_minimum_size.y = add_min_size
	main_container.get_node("GameZone").custom_minimum_size.y = game_min_size
	
	GameUtilityLibrary.SCREEN_WIDTH_PLAY_ZONE = Vector2(0., main_container.size.x)
	GameUtilityLibrary.SCREEN_HEIGHT_PLAY_ZONE = Vector2(add_min_size, add_min_size + game_min_size)
	
	menu_background.position.y = GameUtilityLibrary.SCREEN_HEIGHT - GameUtilityLibrary.get_node_actual_height(menu_background)

#==============================================================================
# SIGNAL FUNCTIONS
#==============================================================================

#func _on_shop_button_pressed():
#	if get_tree().current_scene.name == "reel":
#		SceneManager.change_scene("res://game/scenes/menu/shop/shop.tscn")
#	else:
#		SceneManager.change_scene("res://game/scenes/reel.tscn")


func _process(delta):
	if SInputUtility.is_tapping.value:
		# If input is inside middle button go to shop
		var tapPosition = SInputUtility.tapping_position
		if _check_action_in_button(tapPosition):
			shop_button_pressed()

# Checks if the given position collides with the basketball
func _check_action_in_button( pos : Vector2 ):
	var button_pos = middle_menu_button.global_position
	
	var min_X = button_pos.x
	var max_X = button_pos.x + middle_menu_button.size.x
	var min_Y = button_pos.y
	var max_Y = button_pos.y + middle_menu_button.size.y
	
	var x_bound = pos.x >= min_X and pos.x <= max_X
	var y_bound = pos.y >= min_Y and pos.y <= max_Y
	
	return x_bound and y_bound

func shop_button_pressed():
	if get_tree().current_scene.name == "reel":
		SceneManager.change_scene("res://game/scenes/menu/shop/shop.tscn")
	else:
		SceneManager.change_scene("res://game/scenes/reel.tscn")

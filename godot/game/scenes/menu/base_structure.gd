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
	# Check if the user has bought the ads or not in order to update percentages
	var percentage_menu_background = (GameUtilityLibrary.get_node_actual_height(menu_background)) / GameUtilityLibrary.SCREEN_HEIGHT
	var percentage_add = 0.09
	var percentage_game = 1.0 - percentage_menu_background - percentage_add
	
	print(percentage_add)
	print(percentage_game)
	print(percentage_menu_background)	
	
	print(GameUtilityLibrary.SCREEN_HEIGHT)
	print(GameUtilityLibrary.SCREEN_WIDTH)
	
	ad_view = AdsLibrary.load_show_banner(AdSize.new(-1, 50), AdPosition.Values.TOP)	
		
	main_container.size.x = GameUtilityLibrary.SCREEN_WIDTH
	main_container.size.y = GameUtilityLibrary.SCREEN_HEIGHT
	main_container.get_node("Add").custom_minimum_size.y = GameUtilityLibrary.SCREEN_HEIGHT * percentage_add
	main_container.get_node("GameZone").custom_minimum_size.y = GameUtilityLibrary.SCREEN_HEIGHT * percentage_game
	
	menu_background.position.y = GameUtilityLibrary.SCREEN_HEIGHT - GameUtilityLibrary.get_node_actual_height(menu_background)

#==============================================================================
# SIGNAL FUNCTIONS
#==============================================================================

func _on_shop_button_pressed():
	#SceneManager.change_scene("res://game/scenes/menu/shop/shop.tscn")
	SceneManager.change_scene("res://test/home_godot/shop_ui_test/shop_ui.tscn")

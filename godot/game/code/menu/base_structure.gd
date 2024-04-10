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
var middle_menu_button_rect : Rect2

var first_processed : bool = false

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

func _prepare_button_rects() -> void:
	var button_pos = middle_menu_button.global_position
	
	var posX = button_pos.x
	var sizeX = middle_menu_button.size.x
	var posY = button_pos.y
	var sizeY = middle_menu_button.size.y
	
	middle_menu_button_rect = Rect2(posX, posY, sizeX, sizeY)
#==============================================================================
# SIGNAL FUNCTIONS
#==============================================================================

func _process(delta):
	if !first_processed :
		_prepare_button_rects()
		first_processed = true
	
	if SInputUtility.is_tapping.value:
		# If input is inside middle button go to shop
		var tapPosition = SInputUtility.tapping_position
		if InputDetection.check_position_in_area(tapPosition, middle_menu_button_rect):
			shop_button_pressed()

func shop_button_pressed():
	if get_tree().current_scene.name == "reel":
		SceneManager.change_scene("res://game/scenes/menu/shop/shop.tscn")
	else:
		SceneManager.change_scene("res://game/scenes/reel.tscn")

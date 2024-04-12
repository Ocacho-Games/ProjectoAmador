extends Node

@export var profile_leaderboard_button : PackedScene

@onready var box_container = $HBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	for minigame in SGame.minigames_array:
		var button_node = profile_leaderboard_button.instantiate() as ProfileLeaderboardButton
		button_node.set_properties(minigame)
		box_container.call_deferred("add_child", button_node)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

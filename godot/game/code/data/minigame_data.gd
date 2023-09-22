## "Struct" data for describing a Minigame as a resource
##
class_name SMinigameData extends Resource

# Scene of the minigame
@export var scene 			: PackedScene

# Duration in seconds of the minigame. -1 means infinity duration
@export var game_duration	: float 		= 30

# Minigame key used for identification for localization and so on
@export var game_key		: String		= "my-game-key"

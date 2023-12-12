## "Struct" data for describing a Minigame as a resource
##
class_name SMinigameData extends Resource

#==============================================================================
# TYPES
#==============================================================================

## Gender of the minigame. As Metadata 
enum EGenre {ADVENTURE, ACTION, SPORTS, PLATFORM, RACING, PUZZLE, CASUAL}

#==============================================================================
# VARIABLES
#==============================================================================

# Scene of the minigame
@export var scene 			: PackedScene

# Duration in seconds of the minigame. -1 means infinity duration
@export var game_duration	: float 		= 30

# Unique ID name for each minigame. This will be used for retrieving and saving data for the minigame
@export var game_key		: String		= "my-game-key"

# Array for storing metadata for the minigame. This will be used by the algorithm to provide minigames for the user
@export var metadata		: Array[EGenre]

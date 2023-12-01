## "Struct" data for describing the data we need to save and load on the cloud for each user
## [David]: THE DATA IS A TEST FOR NOW
##
class_name SSaveData

#==============================================================================
# VARIABLES
#==============================================================================

#TODO[David]: I would like to automatize this and the score stuff so we don't need to add the variables manually to the dictionary.

var dictionary = {
	"coins" : 550,
	"clicker_score" : 0,
	# This should be the same name as the bob.tres key. NOTE: This will contain all the unlocked resources "keys" of the colection
	"bob" : ["click_2"],
	"current_bob_sprite" : "",
	"current_bob_sound" : "click_2",
}

#==============================================================================
# FUNCTIONS
#==============================================================================

## Function that describes how data should be copied for this data struct.
## NOTE: The parsed_data must be a parsed JSON
##
func copy_data(parsed_data) -> void:
	dictionary["coins"] = parsed_data.coins	
	dictionary["clicker_score"] = parsed_data.clicker_score
	dictionary["bob"] = parsed_data.bob	
	dictionary["current_bob_sprite"] = parsed_data.current_bob_sprite
	dictionary["current_bob_sound"] = parsed_data.current_bob_sound					

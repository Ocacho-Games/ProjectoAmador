## "Struct" data for describing the data we need to save and load on the cloud for each user
## [David]: THE DATA IS A TEST FOR NOW
##
class_name SSaveData

#==============================================================================
# VARIABLES
#==============================================================================

var dictionary = {
	"clicker_score" : 0,
	# This should be the same name as the bob_skins.tres key
	"bob_skins" : ["black"],
	"current_bob_skins" : "black"
}

#==============================================================================
# FUNCTIONS
#==============================================================================

## Function that describes how data should be copied for this data struct.
## NOTE: The parsed_data must be a parsed JSON
##
func copy_data(parsed_data) -> void:
	dictionary["clicker_score"] = parsed_data.clicker_score
	dictionary["bob-skins"] = parsed_data.bob_skins	
	dictionary["current_bob_skins"] = parsed_data.current_bob_skins		

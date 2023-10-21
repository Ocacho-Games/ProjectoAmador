## "Struct" data for describing the data we need to save and load on the cloud for each user
## [David]: THE DATA IS A TEST FOR NOW
##
class_name SSaveData

#==============================================================================
# VARIABLES
#==============================================================================

var dictionary = {
	"name" : "Jose",
	"test_array" : [] 
}

#==============================================================================
# FUNCTIONS
#==============================================================================

## Function that describes how data should be copied for this data struct.
## NOTE: The parsed_data must be a parsed JSON
##
func copy_data(parsed_data) -> void:
	dictionary["name"] = parsed_data.name
	dictionary["test_array"] = parsed_data.test_array	

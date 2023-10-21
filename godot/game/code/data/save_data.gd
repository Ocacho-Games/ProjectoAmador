## "Struct" data for describing the data we need to save and load on the cloud for each user
## [David]: THE DATA IS A TEST FOR NOW
##
class_name SSaveData

#==============================================================================
# VARIABLES
#==============================================================================

var data = {
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
	data["name"] = parsed_data.name
	data["test_array"] = parsed_data.test_array	

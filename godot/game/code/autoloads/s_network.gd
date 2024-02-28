## Autoload in charge of updating the status of the internet connection
extends HTTPRequest

#==============================================================================
# SIGNALS
#==============================================================================
signal on_connection_success
signal on_connection_failed(code, message)

#==============================================================================
# VARIABLES
#==============================================================================

var last_time_checked : float = 0.0
var wait_time : float = 2.0
var current_time : float = wait_time

# Whether the device is connected to internet or not
var is_connected : bool = false

#==============================================================================
# GODOT FUNCTIONS
#==============================================================================

func _ready():
	_check_connection()
	request_completed.connect(_on_request_result)
	
func _process(delta):
	if current_time <= 0.0:
		_check_connection()
		current_time = wait_time
	else:
		current_time = current_time - delta
		
#==============================================================================
# PRIVATE FUNCTIONS
#==============================================================================

## Performs an HTTPRequest in order to get the result for knowing the internet connection status
## Called from the timer
##
func _check_connection():
	request("http://www.google.com") # This address is only for test. You need to change your trusted and believing return success address...

## Callback from the request function returning the status of the internet connection
##
func _on_request_result(result, _response_code, _headers, _body):
	is_connected = false
	match result:
		RESULT_SUCCESS:
			is_connected = true
			emit_signal("on_connection_success")
		RESULT_CHUNKED_BODY_SIZE_MISMATCH:
			emit_signal("on_connection_failed", RESULT_CHUNKED_BODY_SIZE_MISMATCH, "RESULT_CHUNKED_BODY_SIZE_MISMATCH")
		RESULT_CANT_CONNECT:
			emit_signal("on_connection_failed", RESULT_CANT_CONNECT, "RESULT_CANT_CONNECT")
		RESULT_CANT_RESOLVE:
			emit_signal("on_connection_failed", RESULT_CANT_RESOLVE, "RESULT_CANT_RESOLVE")
		RESULT_CONNECTION_ERROR:
			emit_signal("on_connection_failed", RESULT_CONNECTION_ERROR, "RESULT_CONNECTION_ERROR")
		RESULT_NO_RESPONSE:
			emit_signal("on_connection_failed", RESULT_NO_RESPONSE, "RESULT_NO_RESPONSE")
		RESULT_BODY_SIZE_LIMIT_EXCEEDED:
			emit_signal("on_connection_failed", RESULT_BODY_SIZE_LIMIT_EXCEEDED, "RESULT_BODY_SIZE_LIMIT_EXCEEDED")
		RESULT_REQUEST_FAILED:
			emit_signal("on_connection_failed", RESULT_REQUEST_FAILED, "RESULT_REQUEST_FAILED")
		RESULT_DOWNLOAD_FILE_CANT_OPEN:
			emit_signal("on_connection_failed", RESULT_DOWNLOAD_FILE_CANT_OPEN, "RESULT_DOWNLOAD_FILE_CANT_OPEN")
		RESULT_DOWNLOAD_FILE_WRITE_ERROR:
			emit_signal("on_connection_failed", RESULT_DOWNLOAD_FILE_WRITE_ERROR, "RESULT_DOWNLOAD_FILE_WRITE_ERROR")
		RESULT_REDIRECT_LIMIT_REACHED:
			emit_signal("on_connection_failed", RESULT_REDIRECT_LIMIT_REACHED, "RESULT_REDIRECT_LIMIT_REACHED")	

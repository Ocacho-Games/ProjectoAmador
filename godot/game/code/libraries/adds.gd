class_name AddsLibrary

## Create, load and return an Admob add given the parameters
## [size] : Size of the add, can be predefined values such as BANNER or FULL_BANNER or custom ones
## [position] : Position of the banner in the screen
##
static func load_show_add(size : AdSize = AdSize.BANNER, position : AdPosition.Values = AdPosition.Values.TOP) -> AdView:
	# Current Android ID
	var unit_id = "ca-app-pub-3940256099942544/6300978111"
	var ad_view = AdView.new(unit_id, size, position)
	
	var ad_request = AdRequest.new()
	ad_view.load_ad(ad_request)
	
	return ad_view

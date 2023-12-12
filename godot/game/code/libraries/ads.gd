## Library for loading and showing Admob ads easily
##
class_name AdsLibrary

#==============================================================================
# VARIABLES
#==============================================================================

# Test ID for banner ads (Android/iOS) 
static var banner_id 					: String = "ca-app-pub-3940256099942544/6300978111" if OS.get_name() == "Android" else "ca-app-pub-3940256099942544/2934735716"

# Test ID for interstital ads (Android/iOS)
static var interstital_id 				: String = "ca-app-pub-3940256099942544/1033173712" if OS.get_name() == "Android" else "ca-app-pub-3940256099942544/4411468910"

# Test ID for rewarded ads (Android/iOS)
static var rewarded_id 					: String = "ca-app-pub-3940256099942544/5224354917" if OS.get_name() == "Android" else "ca-app-pub-3940256099942544/1712485313"

# Test ID for rewarded_interstitial ads (Android/iOS)
static var rewarded_interstitial_id 	: String = "ca-app-pub-3940256099942544/5354046379" if OS.get_name() == "Android" else "ca-app-pub-3940256099942544/6978759866"

#==============================================================================
# PUBLIC FUNCTIONS
#==============================================================================

## Create, load and return an Admob Banner add given the parameters
## Make sure to destroy the ad once you are done with it with .destroy()
## [size] : Size of the add, can be predefined values such as BANNER or FULL_BANNER or custom ones
## [position] : Position of the banner in the screen
##
static func load_show_banner(size : AdSize = AdSize.BANNER, position : AdPosition.Values = AdPosition.Values.TOP) -> AdView:
	var ad_view = AdView.new(banner_id, size, position)
	ad_view.load_ad(AdRequest.new())
	
	return ad_view

## Create and return an Admob Interstital
## Make sure to destroy the ad once you are done with it with .destroy()
##
static func load_interstital() -> InterstitialAd:
	return _load_advanced_add(InterstitialAdLoadCallback.new(), InterstitialAdLoader.new(), interstital_id)

## Create, load and return an Admob Interstital
## Make sure to destroy the ad once you are done with it with .destroy()
##	
static func load_show_interstital() -> InterstitialAd:
	return _load_advanced_add(InterstitialAdLoadCallback.new(), InterstitialAdLoader.new(), interstital_id, true)

## Create and return an Admob Rewarded
## Make sure to destroy the ad once you are done with it with .destroy()
##	
static func load_rewarded()-> RewardedAd:
	return _load_advanced_add(RewardedAdLoadCallback.new(), RewardedAdLoader.new(), rewarded_id)

## Create, load and return an Admob Rewarded
## Make sure to destroy the ad once you are done with it with .destroy()
##	
static func load_show_rewarded()-> RewardedAd:
	return _load_advanced_add(RewardedAdLoadCallback.new(), RewardedAdLoader.new(), rewarded_id, true)

## Create and return an Admob Rewarded Interstitial
## Make sure to destroy the ad once you are done with it with .destroy()
##	
static func load_rewarded_interstital() -> RewardedInterstitialAd:
	return _load_advanced_add(RewardedInterstitialAdLoadCallback.new(), RewardedInterstitialAdLoader.new(), rewarded_interstitial_id)

## Create, load and return an Admob Rewarded Interstitial
## Make sure to destroy the ad once you are done with it with .destroy()
##	
static func load_show_rewarded_interstital() -> RewardedInterstitialAd:
	return _load_advanced_add(RewardedInterstitialAdLoadCallback.new(), RewardedInterstitialAdLoader.new(), rewarded_interstitial_id, true)

#==============================================================================
# PRIVATE FUNCTIONS
#==============================================================================

## Create, load and return an advanced Admob Add, based on the instances of the callback, loader and the id of the ad given
## [callback] : Callback in order to attach functionality when the ad performs some action  
## [loader] : Type of loader in order to load the add
## [ad_id] : Test ID of the add
## [show_ad]: Whether we should show the ad once it's loaded or not
##	
static func _load_advanced_add(callback, loader, ad_id, show_ad = false):
	var ad
	
	callback.on_ad_failed_to_load = func(adError : LoadAdError) -> void:
		print(adError.message)

	callback.on_ad_loaded = func(incoming_ad) -> void:
		ad = incoming_ad
		if show_ad:
			ad.show();

	loader.load(ad_id, AdRequest.new(), callback)
	return ad
	

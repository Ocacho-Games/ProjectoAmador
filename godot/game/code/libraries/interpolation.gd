## Library that handles some interpolation functions that aren't provided by Godot itsel
##
class_name InterpolationLibrary

#==============================================================================
# TYPES
#==============================================================================

## Which kind of interpolation do you want to execute
enum EInterpolationType { LINEAR }

## Axis to operate
enum EAxis { X, Y }

#==============================================================================
# FUNCTIONS
#==============================================================================

## Performs a interpolatioin based on the interp_speed. Provoking a smooth interpolation feeling, NOT LINEAR
##
static func interp_to(current, target, delta, interp_speed):
		if interp_speed <= 0.0: return target
	
		var diff = target - current;
		if diff * diff < 0.00001: return target

		var delta_move = diff * clamp(delta * interp_speed, 0.0, 1.0);
		return current + delta_move;	

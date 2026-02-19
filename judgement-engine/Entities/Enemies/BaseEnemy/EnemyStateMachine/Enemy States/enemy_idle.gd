extends State


## Called when the state is entered
func enter_state():
	pass

## Called every frame
func do_process(delta):
	pass

## Called every physics frame
func do_physics_process(delta):
	# Slows the enemy to a stop
	entity.velocity = lerp(entity.velocity, Vector2.ZERO, entity.decceleration * delta)
	
	#If mouse is in detection range, set state to "follow"
	if entity.global_position.distance_to(entity.get_global_mouse_position()) < entity.detection_range:
		set_state("follow")

## Called when the state is exited
func exit_state():
	pass

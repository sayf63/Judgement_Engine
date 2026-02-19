extends State


## Called when the state is entered
func enter_state():
	pass

## Called every frame
func do_process(delta):
	pass

## Called every physics frame
func do_physics_process(delta):
	# Accelerates the enemy toward the mouse
	entity.velocity = lerp(entity.velocity, entity.get_local_mouse_position().normalized() * entity.speed, entity.acceleration * delta)
	
	# Sets state to "idle" if mouse goes out of range
	if entity.global_position.distance_to(entity.get_global_mouse_position()) > entity.detection_range:
		set_state("idle")

## Called when the state is exited
func exit_state():
	pass

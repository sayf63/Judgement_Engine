extends State

@export var acceleration: float

func do_physics_process(delta):
	entity.velocity = lerp(entity.velocity, entity.get_local_mouse_position().normalized() * entity.speed, acceleration * delta)
	
	if entity.distance_to(entity.get_global_mouse_position()) > 300:
		set_state("idle")

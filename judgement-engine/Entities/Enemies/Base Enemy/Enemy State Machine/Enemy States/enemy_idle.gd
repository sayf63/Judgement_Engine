extends State

@export var decceleration: float

func enter_state():
	pass

func do_physics_process(delta):
	entity.velocity = lerp(entity.velocity, Vector2.ZERO, decceleration * delta)

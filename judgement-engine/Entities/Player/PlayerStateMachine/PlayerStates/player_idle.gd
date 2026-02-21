extends State

## Called when the state is entered
func enter_state():
	entity.velocity = Vector2.ZERO

## Called every frame
func do_physics_process(_delta):
	entity.velocity = Vector2.ZERO
	if entity.global_position.distance_to(entity.get_global_mouse_position()) > entity.STOP_RADIUS:
		if entity.cooldowns["Dashing"] < entity.DASH_COOLDOWN - entity.DASH_DURATION:
			set_state("Moving")
		else:
			set_state("Dashing")
	
	if Input.is_action_just_pressed("dash") && !entity.is_on_cooldown("Dashing"):
		set_state("Dashing")
	entity.move_and_slide()

## Called when the state is exited
func exit_state():
	pass

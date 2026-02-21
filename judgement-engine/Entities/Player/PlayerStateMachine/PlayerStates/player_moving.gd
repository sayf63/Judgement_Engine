extends State

## Called every physics frame
func do_physics_process(delta):
	if Input.is_action_just_pressed("dash") && !entity.is_on_cooldown("Dashing"):
		set_state("Dashing")
	 
	
	var mouse_position = entity.get_global_mouse_position()
	var distance = entity.position.distance_to(mouse_position)
	if distance < entity.STOP_RADIUS or Input.is_action_pressed("anchor"):
		set_state("Idle")
	
	var min_speed_factor := 0.1
	var t := smoothstep(0.0, entity.SLOW_RADIUS, distance)
	var target_speed_multiplier = lerp(min_speed_factor, 1.0, t)
	
	var direction = entity.position.direction_to(mouse_position)
	entity.velocity = entity.velocity.move_toward(
		direction*entity.SPEED*target_speed_multiplier*delta*50,
		entity.SPEED
	)
	entity.move_and_slide()

## Called when the state is exited
func exit_state():
	pass

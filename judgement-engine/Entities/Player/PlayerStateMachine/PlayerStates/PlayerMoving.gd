extends State

## Called when the state is entered
func enter_state():
	pass

## Called every frame
func do_process(_delta):
	pass

## Called every physics frame
func do_physics_process(delta):
	if Input.is_action_just_pressed("dash") && !entity.is_on_cooldown("Dashing"):
		set_state("Dashing")
	
	var mouse_position = entity.get_global_mouse_position()
	var distance = entity.position.distance_to(mouse_position)
	if distance < entity.STOP_RADIUS:
		set_state("Idle")
	
	var min_speed_factor := 0.1
	var t := smoothstep(0.0, entity.SLOW_RADIUS, distance)
	var target_speed_multiplier = lerp(min_speed_factor, 1.0, t)
	
	var direction = entity.position.direction_to(mouse_position)
	entity.velocity = Vector2(
		move_toward(entity.velocity.x, direction.x * entity.SPEED * target_speed_multiplier * delta*50, entity.SPEED),
		move_toward(entity.velocity.y, direction.y * entity.SPEED * target_speed_multiplier * delta*50, entity.SPEED)
	)
	entity.move_and_slide()

## Called when the state is exited
func exit_state():
	pass

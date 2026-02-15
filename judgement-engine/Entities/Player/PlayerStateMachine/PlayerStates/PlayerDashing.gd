extends State

var dash_duration: float = 1

## Called when the state is entered
func enter_state():
	dash_duration = entity.DASH_DURATION
	entity.cooldowns["Dashing"] = entity.DASH_COOLDOWN

## Called every frame
func do_process(_delta):
	pass

## Called every physics frame
func do_physics_process(delta):
	dash_duration -= delta
	if dash_duration <= 0:
		set_state("Moving")
	
	var target_speed_multiplier = entity.DASH_MULTIPLIER
	var mouse_position = entity.get_global_mouse_position()
	
	var distance = entity.position.distance_to(mouse_position)
	if distance < entity.STOP_RADIUS:
		set_state("Idle")
	
	var direction = entity.position.direction_to(mouse_position)
	entity.velocity = Vector2(
		move_toward(entity.velocity.x, direction.x * entity.SPEED * target_speed_multiplier * delta*50, entity.SPEED),
		move_toward(entity.velocity.y, direction.y * entity.SPEED * target_speed_multiplier * delta*50, entity.SPEED)
	)
	
	entity.move_and_slide()

## Called when the state is exited
func exit_state():
	pass

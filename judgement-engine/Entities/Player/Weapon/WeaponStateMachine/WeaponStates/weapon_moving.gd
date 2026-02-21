extends State

func do_physics_process(delta):
	var mouse_position = entity.get_global_mouse_position()
	var direction = entity.position.direction_to(mouse_position)
	entity.velocity = entity.velocity.move_toward(
		direction*entity.SPEED*50,
		entity.ACCEL*delta
	)
	if entity.velocity.length() > entity.SPEED:
		entity.velocity = entity.velocity.normalized() * entity.SPEED
	# steer velocity towards cursor slightly
	var vel_dir = entity.velocity.normalized()
	var dot = vel_dir.dot(direction)
	
	var angle_limit = deg_to_rad(20)
	var cos_limit = cos(angle_limit)
	
	if dot < cos_limit:
		var curr_speed = entity.velocity.length()
		var new_angle = rotate_toward(entity.velocity.angle(), direction.angle(), entity.STEER_STRENGTH/100)
		
		entity.velocity = Vector2.from_angle(new_angle) * curr_speed

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("swing") && entity.cooldowns["Swinging"] == 0:
		set_state("Swinging")

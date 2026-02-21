class_name WeaponStateMachine
extends StateMachine

func _physics_process(delta):
	if current_state:
		current_state.do_physics_process(delta)
	
	_reflect_off_edge()
	
	entity.move_and_slide()

func _reflect_off_edge():
	var screen_rect = _get_camera_rect()
	if screen_rect == Rect2():
		screen_rect = get_viewport().get_visible_rect()
	var pos = entity.global_position
	var vel = entity.velocity
	var bounced = false
	
	# Left
	if pos.x < screen_rect.position.x:
		pos.x = screen_rect.position.x+1
		vel.x *= -1
		bounced = true
	
	# Right
	elif pos.x > screen_rect.end.x:
		pos.x = screen_rect.end.x-1
		vel.x *= -1
		bounced = true
	
	# Top
	if pos.y < screen_rect.position.y:
		pos.y = screen_rect.position.y+1
		vel.y *= -1
		bounced = true
	
	# Bottom
	elif pos.y > screen_rect.end.y:
		pos.y = screen_rect.end.y-1
		vel.y *= -1
		bounced = true
	
	if bounced:
		vel *= 0.8
	
	entity.global_position = pos
	entity.velocity = vel

func _get_camera_rect() -> Rect2:
	var camera := get_viewport().get_camera_2d()
	if camera == null:
		return Rect2()
	
	var viewport_size = get_viewport().get_visible_rect().size
	
	var zoom = camera.zoom
	
	var size = viewport_size * zoom
	var top_left = camera.global_position - size * 0.5
	
	return Rect2(top_left, size)

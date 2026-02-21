class_name WeaponStateMachine
extends StateMachine

func _physics_process(delta):
	if current_state:
		current_state.do_physics_process(delta)
	
	_reflect_off_edge()
	
	entity.move_and_slide()

func _reflect_off_edge():
	var screen_rect = get_viewport().get_visible_rect()
	var pos = entity.global_position
	var vel = entity.velocity
	var bounced = false
	
	# Left edge
	if pos.x < screen_rect.position.x:
		pos.x = screen_rect.position.x+1
		vel.x *= -1
		bounced = true
	
	# Right edge
	elif pos.x > screen_rect.end.x:
		pos.x = screen_rect.end.x-1
		vel.x *= -1
		bounced = true
	
	# Top edge
	if pos.y < screen_rect.position.y:
		pos.y = screen_rect.position.y+1
		vel.y *= -1
		bounced = true
	
	# Bottom edge
	elif pos.y > screen_rect.end.y:
		pos.y = screen_rect.end.y-1
		vel.y *= -1
		bounced = true
	
	if bounced:
		# optional: reduce energy so it doesn’t bounce forever
		vel *= 0.8
	
	entity.global_position = pos
	entity.velocity = vel

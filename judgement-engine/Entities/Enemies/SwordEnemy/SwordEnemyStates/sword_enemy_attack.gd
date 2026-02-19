extends EnemyAttackState

var direction: Vector2
@export var lunge_speed: int

func enter_state():
	direction = entity.to_local(entity.player.global_position).normalized()
	super.enter_state()

func do_attack():
	entity.velocity = direction * lunge_speed
	hurtbox.rotation = direction.angle() + PI/2

func do_physics_process(delta):
	if attacking:
		hurtbox.rotation = lerp(hurtbox.rotation, direction.angle() + (3*PI/2), execution_time / delta)
	else:
		entity.velocity = Vector2.ZERO

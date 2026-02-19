class_name EnemyState
extends State


func deccelerate(delta):
	entity.velocity = lerp(entity.velocity, Vector2.ZERO, entity.decceleration * delta)

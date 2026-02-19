class_name EnemyAttackState
extends EnemyState


@export var delay_time: float
@export var execution_time: float
@export var recover_time: float

@onready var hurtbox: Area2D = get_child(0)

var attacking: bool = false

# Inputs
func enter_state():
	entity.velocity = Vector2.ZERO
	await get_tree().create_timer(delay_time).timeout
	attacking = true
	do_attack()
	await get_tree().create_timer(execution_time).timeout
	attacking = false
	await get_tree().create_timer(recover_time).timeout
	set_state(state_machine.default_state)


# Internal
func _ready():
	if hurtbox:
		hurtbox.body_entered.connect(damage_player)

func do_attack():
	pass



# Outputs
func damage_player(body):
	if body is Player:
		pass
		# Make player take damage

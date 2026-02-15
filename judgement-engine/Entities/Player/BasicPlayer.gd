extends CharacterBody2D


@export var SPEED = 500.0
@export var ACCEL = SPEED/10

const ACTIONS = {
	Move_Left = "left",
	Move_Right = "right",
	Move_Up = "up",
	Move_Down = "down",
	Dash = "dash"
}

var previous_direction := Vector2.ZERO

func _physics_process(_delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var x_dir = Input.get_axis(ACTIONS.Move_Left, ACTIONS.Move_Right)
	var y_dir = Input.get_axis(ACTIONS.Move_Up, ACTIONS.Move_Down)
	
	velocity.x = move_toward(velocity.x, x_dir * SPEED, ACCEL)
	velocity.y = move_toward(velocity.y, y_dir * SPEED, ACCEL)
	
	move_and_slide()

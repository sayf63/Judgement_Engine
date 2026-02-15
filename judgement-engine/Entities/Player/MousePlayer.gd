extends CharacterBody2D


@export var SPEED := 400.0
@export var DASH_MULTIPLIER := 2.0
@export var DASH_COOLDOWN := 2.0
@export var DASH_DURATION := 1.0
@export var WEAPON_DISTANCE := 100.0
@export var WEAPON_ROTATION_SPEED := 10.0

@onready var Weapon = $PlayerWeapon

var dash_is_cooldown := false

const ACTIONS = {
	Move_Left = "left",
	Move_Right = "right",
	Move_Up = "up",
	Move_Down = "down",
	Dash = "dash"
}

enum STATES {
	MOVING,
	IDLE,
	DASHING
}

var state := STATES.IDLE

var cooldowns: Dictionary = {
	ACTIONS.Dash: DASH_COOLDOWN
}

func _is_on_cooldown(action: String) -> bool:
	return cooldowns[action] != 0

var previous_direction := Vector2.ZERO

func _init() -> void:
	for key in cooldowns:
		cooldowns[key] = 0

func set_state(new_state: STATES) -> void:
	var previous_state = state
	state = new_state
	
	match state:
		STATES.MOVING:
			pass
		STATES.IDLE:
			pass
		STATES.DASHING:
			cooldowns[ACTIONS.Dash] = DASH_COOLDOWN
			get_tree().create_timer(DASH_DURATION).timeout.connect(
				func(): state = STATES.MOVING
			)
		_:
			pass

func _physics_process(delta: float) -> void:
	for key in cooldowns:
		cooldowns[key] = max(cooldowns[key] - delta, 0.0)
	
	var mouse_position = get_global_mouse_position()
	
	handle_mouse_movement(delta, mouse_position)
	
	if Input.is_action_just_pressed(ACTIONS.Dash) and !_is_on_cooldown(ACTIONS.Dash) and state != STATES.DASHING:
		set_state(STATES.DASHING)
	
	handle_weapon_position(delta, mouse_position)
	
	move_and_slide()
	if velocity == Vector2.ZERO:
		set_state(STATES.IDLE)
	elif state != STATES.DASHING:
		set_state(STATES.MOVING)
	print(state)

func handle_weapon_position(delta: float, mouse_position: Vector2):
	var weapon_desired_angle := global_position.angle_to_point(mouse_position)
	Weapon.rotation = lerp_angle(
		Weapon.rotation,
		weapon_desired_angle,
		WEAPON_ROTATION_SPEED * delta
	)
	Weapon.position = Vector2.RIGHT.rotated(Weapon.rotation) * WEAPON_DISTANCE

func handle_mouse_movement(delta, mouse_position: Vector2):
	var distance = position.distance_to(mouse_position)
	if distance < 5:
		velocity = Vector2.ZERO
		return
	
	var target_speed_multiplier = 1
	
	var slow_radius := 75.0
	var min_speed_factor := 0.1
	var t := smoothstep(0.0, slow_radius, distance)
	target_speed_multiplier = lerp(min_speed_factor, 1.0, t)
	
	if state == STATES.DASHING:
		target_speed_multiplier += DASH_MULTIPLIER-1
	
	var direction = position.direction_to(mouse_position)
	velocity = Vector2(
		move_toward(velocity.x, direction.x * SPEED * target_speed_multiplier * delta*50, SPEED),
		move_toward(velocity.y, direction.y * SPEED * target_speed_multiplier * delta*50, SPEED)
	)

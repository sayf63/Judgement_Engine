extends CharacterBody2D


@export var SPEED := 400.0
@export var DASH_MULTIPLIER := 2.0
@export var DASH_COOLDOWN := 1.0
@export var DASH_DURATION := 1.0
@export var WEAPON_DISTANCE := 100.0
@export var WEAPON_ROTATION_SPEED := 10.0

@onready var Weapon = $PlayerWeapon

var dash_timer := 0.0
var is_dashing := false
var dash_is_cooldown := false

const ACTIONS = {
	Move_Left = "left",
	Move_Right = "right",
	Move_Up = "up",
	Move_Down = "down",
	Dash = "dash"
}

var previous_direction := Vector2.ZERO

func _physics_process(delta: float) -> void:
	var mouse_position = get_global_mouse_position()
	
	handle_mouse_movement(delta, mouse_position)
	
	handle_dash(delta)
	
	handle_weapon_position(delta, mouse_position)
	
	move_and_slide()

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
	
	if is_dashing:
		target_speed_multiplier += DASH_MULTIPLIER-1
	
	var direction = position.direction_to(mouse_position)
	velocity = Vector2(
		move_toward(velocity.x, direction.x * SPEED * target_speed_multiplier * delta*50, SPEED),
		move_toward(velocity.y, direction.y * SPEED * target_speed_multiplier * delta*50, SPEED)
	)

func handle_dash(delta: float) -> void:
	if Input.is_action_just_pressed(ACTIONS.Dash) && !dash_is_cooldown:
		is_dashing = true
	
	if is_dashing:
		dash_timer += delta
		if dash_timer > DASH_DURATION:
			dash_timer = 0
			is_dashing = false
			dash_is_cooldown = true
	
	if dash_is_cooldown:
		dash_timer += delta
		if dash_timer > DASH_COOLDOWN:
			dash_is_cooldown = false
			dash_timer = 0

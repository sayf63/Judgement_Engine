extends CharacterBody2D


@export var SPEED := 400.0
@export var DASH_MULTIPLIER := 2.0
@export var DASH_COOLDOWN := 1.0
@export var DASH_DURATION := 1.0

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
	handle_mouse_movement()
	
	handle_dash(delta)
	
	move_and_slide()

func handle_mouse_movement():
	var mouse_position = get_global_mouse_position()
	
	var distance = position.distance_to(mouse_position)
	if distance < 5:
		velocity = Vector2.ZERO
	else:
		var target_speed_multiplier = 1
		
		var slow_radius := 50.0
		var min_speed_factor := 0.1
		var t := smoothstep(0.0, slow_radius, distance)
		target_speed_multiplier = lerp(min_speed_factor, 1.0, t)
		
		if is_dashing:
			target_speed_multiplier += DASH_MULTIPLIER-1
		
		var direction = position.direction_to(mouse_position)
		velocity = Vector2(
			move_toward(velocity.x, direction.x * SPEED * target_speed_multiplier, SPEED),
			move_toward(velocity.y, direction.y * SPEED * target_speed_multiplier, SPEED)
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

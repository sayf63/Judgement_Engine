class_name Player
extends CharacterBody2D

signal player_hurt(health_change)
signal player_healed(health_change)

@export var SPEED := 200.0:
	set(value):
		# if we focus mode
		if value*FOCUS_SPEED_SLOWDOWN == SPEED:
			SPEED = value
		else:
			real_max_speed = value
			SPEED = value
@export var FOCUS_SPEED_SLOWDOWN := 2.0
@export var DASH_MULTIPLIER := 2.0
@export var DASH_COOLDOWN := 2.0
@export var DASH_DURATION := 1.0
@export var WEAPON_DISTANCE := 100.0
@export var WEAPON_ROTATION_SPEED := 10.0
@export var SLOW_RADIUS = 50.0
@export var STOP_RADIUS = 5

var real_max_speed := SPEED

@export var MAX_HEALTH = 100
@export var current_health = MAX_HEALTH:
	set(value):
		if value < current_health:
			print("player was hurt :(")
			emit_signal("player_hurt", value - current_health)
		elif value > current_health:
			print("player was healed :)")
			emit_signal("player_healed", value - current_health)
		else:
			print("Player's health was set to what it already was...")
		
		current_health = value

@onready var Weapon = $PlayerWeapon
@onready var States = $StateMachine

var cooldowns: Dictionary = {
	"Dashing": DASH_COOLDOWN
}

func _init() -> void:
	for key in cooldowns:
		cooldowns[key] = 0

func _process(delta: float) -> void:
	for key in cooldowns:
		cooldowns[key] = max(cooldowns[key] - delta, 0.0)
	
	#handle_weapon_position(delta, get_global_mouse_position())

func _physics_process(_delta: float) -> void:
	if cooldowns["Dashing"] > DASH_COOLDOWN - DASH_DURATION:
		pass # invicible
	if Input.is_action_just_pressed("slowdown"):
		SPEED /= FOCUS_SPEED_SLOWDOWN
	elif Input.is_action_just_released("slowdown"):
		SPEED = real_max_speed

func is_on_cooldown(action: String) -> bool:
	return cooldowns[action] > 0

func handle_weapon_position(delta: float, mouse_position: Vector2):
	var weapon_desired_angle := global_position.angle_to_point(mouse_position)
	Weapon.rotation = rotate_toward(
		Weapon.rotation,
		weapon_desired_angle,
		WEAPON_ROTATION_SPEED * delta
	)
	Weapon.position = Vector2.RIGHT.rotated(Weapon.rotation) * WEAPON_DISTANCE

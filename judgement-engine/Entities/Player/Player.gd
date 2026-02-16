class_name Player
extends CharacterBody2D

@export var SPEED := 200.0
@export var DASH_MULTIPLIER := 2.0
@export var DASH_COOLDOWN := 2.0
@export var DASH_DURATION := 1.0
@export var WEAPON_DISTANCE := 100.0
@export var WEAPON_ROTATION_SPEED := 10.0
@export var SLOW_RADIUS = 75.0
@export var STOP_RADIUS = 5

@onready var Weapon = $PlayerWeapon

var cooldowns: Dictionary = {
	"Dashing": DASH_COOLDOWN
}

func _init() -> void:
	for key in cooldowns:
		cooldowns[key] = 0

func _process(delta: float) -> void:
	for key in cooldowns:
		cooldowns[key] = max(cooldowns[key] - delta, 0.0)
	
	handle_weapon_position(delta, get_global_mouse_position())

func _physics_process(_delta: float) -> void:
	if cooldowns["Dashing"] > DASH_COOLDOWN - DASH_DURATION:
		print("I'M FUCKING INVICIBLE")
		print("---------------")
		pass # invicible

func is_on_cooldown(action: String) -> bool:
	return cooldowns[action] > 0

func handle_weapon_position(delta: float, mouse_position: Vector2):
	var weapon_desired_angle := global_position.angle_to_point(mouse_position)
	Weapon.rotation = lerp_angle(
		Weapon.rotation,
		weapon_desired_angle,
		WEAPON_ROTATION_SPEED * delta
	)
	Weapon.position = Vector2.RIGHT.rotated(Weapon.rotation) * WEAPON_DISTANCE

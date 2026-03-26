class_name Weapon
extends CharacterBody2D

@onready var player = get_parent()

@export var ACCEL := 500.0
@export var DAMAGE := 10.0
@export var SPEED := 1000.0
@export var SWING_CD := 1.0
@export var STEER_STRENGTH := 10.0
@export var SWING_ARC_SIZE := 100.0

@onready var sprite = $Sprite2D

var cooldowns: Dictionary = {
	"Swinging": SWING_CD
}

func _init() -> void:
	for key in cooldowns:
		cooldowns[key] = 0.0

func _ready() -> void:
	position = player.position

func _process(delta: float) -> void:
	for key in cooldowns:
		cooldowns[key] = max(cooldowns[key] - delta, 0.0)
	sprite.rotate(10*delta)
	

func _on_area_2d_area_entered(area: Area2D) -> void:
	var enemy = area.get_parent()
	if enemy is Enemy:
		enemy.take_damage( DAMAGE * min(1.5, (velocity.length()/SPEED)) )

func reset_cooldown(key: String) -> void:
	match key:
		"Swinging":
			cooldowns["Swinging"] = SWING_CD
		_:
			pass

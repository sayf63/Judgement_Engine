class_name Enemy
extends CharacterBody2D


signal damaged

var player: Node

@export_group("Enemy Stats")
@export var max_health: int
@onready var health: int = max_health
@export var defense: int

@export var speed: int
@export var acceleration: float
@export var decceleration: float

@export var detection_range: int

# Inputs
func take_damage(damage: int):
	health -= damage
	# Keeps enemy health between 0 and max_health
	health = clamp(health, 0, max_health)
	damaged.emit()

# Internal
func _physics_process(delta):
	if health <= 0:
		die()

# Outputs
func die():
	queue_free()

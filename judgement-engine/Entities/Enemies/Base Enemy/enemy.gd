class_name Enemy
extends CharacterBody2D

var player: Node

@export var max_health: int
@onready var health = max_health

@export var defense: int

@export var speed: int
@export var acceleration: float
@export var decceleration: float

@export var detection_range: int

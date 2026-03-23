@tool
class_name Projectile
extends CharacterBody2D

@onready var shadow = $shadow
@onready var sprite = $sprite
@onready var collider = $hurtbox/collider

@export var proj_resource: ProjectileResource

const SHADOW_RATIO: float = 0.05

var available: bool = true
var active: bool = false
var starting_position: Vector2

func spawn(direction: Vector2, spawn_position: Vector2, Proj_Resource: ProjectileResource):
	if available:
		available = false
		active = true
		proj_resource = Proj_Resource
		update_projectile_type()
		
		global_position = spawn_position
		starting_position = spawn_position
		collider.set_deferred("disabled", false)
		velocity = direction.normalized() * proj_resource.speed
		sprite.rotation = direction.angle()
		show()

func _process(delta):
	if Engine.is_editor_hint():
		update_projectile_type()

func _physics_process(delta):
	if active:
		if global_position.distance_to(starting_position) >= proj_resource.range:
			despawn()

func update_projectile_type():
	if proj_resource:
		sprite.texture = proj_resource.sprite
		shadow.scale = Vector2(proj_resource.collider_radius * SHADOW_RATIO, proj_resource.collider_radius * SHADOW_RATIO)
		collider.shape.radius = proj_resource.collider_radius
	else:
		sprite.texture = null
		collider.shape.radius = 0
		shadow.scale = Vector2.ZERO

func _on_hurtbox_body_entered(body):
	if body is Player:
		# Make player take damage
		despawn()

func despawn():
	if active:
		active = false
		collider.set_deferred("disabled", true)
		hide()
		global_position = Vector2.ZERO

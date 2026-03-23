extends Node2D

@export var initial_amount: int
@export var proj_scene: PackedScene

func _ready():
	add_to_pool(initial_amount)

func spawn_proj(direction: Vector2, spawn_pos: Vector2, proj_resource: ProjectileResource):
	if available_projectiles().is_empty():
		add_to_pool(1)
		available_projectiles()[0].spawn(direction, spawn_pos, proj_resource)
	else:
		available_projectiles()[0].spawn(direction, spawn_pos, proj_resource)

func add_to_pool(amount: int):
	for i in amount:
		var new_proj = proj_scene.instantiate()
		add_child(new_proj)

func available_projectiles() -> Array:
	var available_projs = []
	for i in get_children():
		if i.available:
			available_projs.append(i)
	return available_projs

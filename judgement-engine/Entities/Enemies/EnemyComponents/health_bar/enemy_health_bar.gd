extends ProgressBar

@onready var entity: Enemy = $".."

func _ready():
	hide()
	await get_tree().create_timer(0.01).timeout
	update_display()
	
	entity.damaged.connect(update_display)

func update_display():
	max_value = entity.max_health
	value = entity.health
	
	set_deferred("visible", entity.health != entity.max_health)

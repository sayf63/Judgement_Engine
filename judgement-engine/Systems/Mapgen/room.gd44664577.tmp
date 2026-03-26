extends Node2D

signal player_entered_door(room_node, direction)

func setup(connections: Array, room_type: String, door_leads: Dictionary):
	var doors = {
		"north": $DoorNorth,
		"south": $DoorSouth,
		"east":  $DoorEast,
		"west":  $DoorWest
	}

	for dir in doors:
		var door = doors[dir]
		var color_rect = door.get_node("ColorRect")

		if room_type == "boss" or room_type == "shop":
			door.visible = (dir in connections)
			color_rect.color = Color.WHITE
		else:
			if dir in connections:
				door.visible = true
				match door_leads[dir]:
					"boss": color_rect.color = Color.RED
					"shop": color_rect.color = Color.YELLOW
					_:     color_rect.color = Color.WHITE
			else:
				door.visible = false

		if door.visible:
			var d = dir
			door.body_entered.connect(func(body):
				if body is CharacterBody2D:
					player_entered_door.emit(self, d)
			)

	# Spawn indicator square for special rooms
	if room_type == "boss":
		var indicator = ColorRect.new()
		indicator.size = Vector2(32, 32)
		indicator.position = Vector2(304, 304)
		indicator.color = Color.RED
		add_child(indicator)
	elif room_type == "shop":
		var indicator = ColorRect.new()
		indicator.size = Vector2(32, 32)
		indicator.position = Vector2(304, 304)
		indicator.color = Color.YELLOW
		add_child(indicator)

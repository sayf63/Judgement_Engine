extends Node2D

@export var room_scene: PackedScene
@export var boss_room_scene: PackedScene
@export var shop_room_scene: PackedScene
@export var player_scene: PackedScene
@export var map_width: int = 7
@export var map_height: int = 7
@export var room_size: int = 640
@export var room_count: int = 8

var grid = []
var player = null
var current_room = null

const DIRECTIONS = [[1,0], [-1,0], [0,1], [0,-1]]
const DIR_NAMES  = ["east", "west", "south", "north"]
const OPPOSITE   = [1, 0, 3, 2]

const DIR_OPPOSITE_NAME = {
	"north": "south",
	"south": "north",
	"east":  "west",
	"west":  "east"
}

const ENTRY_OFFSET = {
	"north": Vector2(320, 80),
	"south": Vector2(320, 560),
	"east":  Vector2(560, 320),
	"west":  Vector2(80, 320)
}

func _ready():
	generate_connected_map()
	spawn_player()


func spawn_player():
	player = player_scene.instantiate()
	for room in get_children():
		if not room.has_meta("grid_x"):
			continue
		var x = room.get_meta("grid_x")
		var y = room.get_meta("grid_y")
		if grid[x][y]["type"] == "start":
			current_room = room
			player.position = room.position + Vector2(320,320)
		room.visible = false
	current_room.visible = true
	add_child(player)
	$Camera2D.position = current_room.position + Vector2(320,320)


func generate_connected_map():
	randomize()
	grid = []
	for x in range(map_width):
		grid.append([])
		for y in range(map_height):
			grid[x].append({
				"exists": false,
				"neighbors": 0,
				"type": "normal",
				"connections": []
			})
	
	var current_x = map_width / 2
	var current_y = map_height / 2
	place_room(current_x, current_y, "start")
	var rooms_spawned = 1
	
	var start_x = current_x
	var start_y = current_y
	var start_connections = 0
	
	while start_connections < 2 and rooms_spawned < room_count:
		for i in range(DIRECTIONS.size()):
			if start_connections >= 2:
				break
			var dir = DIRECTIONS[i]
			var nx = start_x + dir[0]
			var ny = start_y + dir[1]
			if nx >= 0 and nx < map_width and ny >= 0 and ny < map_height:
				if not grid[nx][ny]["exists"]:
					place_room(nx, ny, "normal")
					grid[start_x][start_y]["connections"].append(DIR_NAMES[i])
					grid[nx][ny]["connections"].append(DIR_NAMES[OPPOSITE[i]])
					grid[start_x][start_y]["neighbors"] += 1
					grid[nx][ny]["neighbors"] += 1
					current_x = nx
					current_y = ny
					rooms_spawned += 1
					start_connections += 1

	while rooms_spawned < room_count:
		var empty_neighbors = []
		for i in range(DIRECTIONS.size()):
			var dir = DIRECTIONS[i]
			var nx = current_x + dir[0]
			var ny = current_y + dir[1]
			if nx >= 0 and nx < map_width and ny >= 0 and ny < map_height:
				if not grid[nx][ny]["exists"] and grid[current_x][current_y]["neighbors"] < 2:
					empty_neighbors.append([nx, ny, i])

		if empty_neighbors.size() == 0:
			var existing_rooms = []
			for x in range(map_width):
				for y in range(map_height):
					if grid[x][y]["exists"] and grid[x][y]["neighbors"] < 2:
						existing_rooms.append([x, y])
			if existing_rooms.size() == 0:
				break
			var choice = existing_rooms[randi() % existing_rooms.size()]
			current_x = choice[0]
			current_y = choice[1]
			continue

		var next_cell = empty_neighbors[randi() % empty_neighbors.size()]
		var nx = next_cell[0]
		var ny = next_cell[1]
		var dir_index = next_cell[2]

		place_room(nx, ny, "normal")
		grid[current_x][current_y]["connections"].append(DIR_NAMES[dir_index])
		grid[nx][ny]["connections"].append(DIR_NAMES[OPPOSITE[dir_index]])
		grid[current_x][current_y]["neighbors"] += 1
		grid[nx][ny]["neighbors"] += 1
		current_x = nx
		current_y = ny
		rooms_spawned += 1

	assign_boss_room()
	assign_shop_room()
	apply_doors_to_all_rooms()


func place_room(x, y, room_type):
	grid[x][y]["exists"] = true
	grid[x][y]["type"] = room_type

	var room
	match room_type:
		"boss": room = boss_room_scene.instantiate()
		"shop": room = shop_room_scene.instantiate()
		_:      room = room_scene.instantiate()

	room.position = Vector2(
		(x - map_width / 2) * room_size + room_size / 2,
		(y - map_height / 2) * room_size + room_size / 2
	)
	room.set_meta("grid_x", x)
	room.set_meta("grid_y", y)

	match room_type:
		"start": room.modulate = Color.GREEN
		"boss":  room.modulate = Color.RED
		"shop":  room.modulate = Color.YELLOW
		"normal": room.modulate = Color.WHITE

	add_child(room)


func apply_doors_to_all_rooms():
	for room in get_children():
		if not room.has_meta("grid_x"):
			continue
		var x = room.get_meta("grid_x")
		var y = room.get_meta("grid_y")
		var room_type = grid[x][y]["type"]
		var connections = grid[x][y]["connections"]

		var door_leads = {}
		for i in range(connections.size()):
			var dir = connections[i]
			var offset = DIR_NAMES.find(dir)
			var nx = x + DIRECTIONS[offset][0]
			var ny = y + DIRECTIONS[offset][1]
			door_leads[dir] = grid[nx][ny]["type"]
		
		room.player_entered_door.connect(_on_player_entered_door)
		room.setup(connections, room_type, door_leads)


func _on_player_entered_door(from_room, direction):
	var x = from_room.get_meta("grid_x")
	var y = from_room.get_meta("grid_y")
	var offset = DIR_NAMES.find(direction)
	var nx = x + DIRECTIONS[offset][0]
	var ny = y + DIRECTIONS[offset][1]
	
	var dest_room = null
	for room in get_children():
		if not room.has_meta("grid_x"):
			continue
		if room.get_meta("grid_x") == nx and room.get_meta("grid_y") == ny:
			dest_room = room
			break

	if dest_room == null:
		return

	transition_to_room(dest_room, direction)


func transition_to_room(dest_room, entered_from_direction):
	player.set_physics_process(false)

	var fade = $CanvasLayer/fade
	var tween = create_tween()
	tween.tween_property(fade, "modulate:a", 1.0, 0.3)
	await tween.finished

	current_room.visible = false
	dest_room.visible = true
	current_room = dest_room

	var entry_dir = DIR_OPPOSITE_NAME[entered_from_direction]
	player.position = dest_room.position + ENTRY_OFFSET[entry_dir]
	$Camera2D.position = dest_room.position + Vector2(320,320)

	var tween2 = create_tween()
	tween2.tween_property(fade, "modulate:a", 0.0, 0.3)
	await tween2.finished

	player.set_physics_process(true)


func assign_boss_room():
	var candidates = []
	for x in range(map_width):
		for y in range(map_height):
			if grid[x][y]["exists"] and grid[x][y]["type"] == "normal":
				candidates.append([x, y])

	if candidates.size() == 0:
		return

	var start_x = map_width / 2
	var start_y = map_height / 2
	var farthest_distance = -1
	var farthest_room = candidates[0]

	for cell in candidates:
		var x = cell[0]
		var y = cell[1]
		var distance = (x - start_x) * (x - start_x) + (y - start_y) * (y - start_y)
		if distance > farthest_distance:
			farthest_distance = distance
			farthest_room = cell

	grid[farthest_room[0]][farthest_room[1]]["type"] = "boss"
	_recolor_room(farthest_room[0], farthest_room[1], Color.RED)


func assign_shop_room():
	var start_x = map_width / 2
	var start_y = map_height / 2

	var start_neighbors = []
	for i in range(DIRECTIONS.size()):
		var nx = start_x + DIRECTIONS[i][0]
		var ny = start_y + DIRECTIONS[i][1]
		if nx >= 0 and nx < map_width and ny >= 0 and ny < map_height:
			if grid[nx][ny]["exists"]:
				start_neighbors.append([nx, ny])

	var normal_rooms = []
	for x in range(map_width):
		for y in range(map_height):
			if grid[x][y]["exists"] and grid[x][y]["type"] == "normal" and grid[x][y]["neighbors"] == 1:
				if not [x, y] in start_neighbors:
					if is_reachable_without_boss(x, y):
						normal_rooms.append([x, y])

	if normal_rooms.size() == 0:
		for x in range(map_width):
			for y in range(map_height):
				if grid[x][y]["exists"] and grid[x][y]["type"] == "normal":
					if not [x, y] in start_neighbors:
						if is_reachable_without_boss(x, y):
							normal_rooms.append([x, y])

	if normal_rooms.size() == 0:
		return

	var choice = normal_rooms[randi() % normal_rooms.size()]
	grid[choice[0]][choice[1]]["type"] = "shop"
	_recolor_room(choice[0], choice[1], Color.YELLOW)


func is_reachable_without_boss(tx, ty):
	var start_x = map_width / 2
	var start_y = map_height / 2
	var visited = []
	var queue = [[start_x, start_y]]
	while queue.size() > 0:
		var current = queue.pop_front()
		var cx = current[0]
		var cy = current[1]
		if [cx, cy] in visited:
			continue
		visited.append([cx, cy])
		if cx == tx and cy == ty:
			return true
		for dir in grid[cx][cy]["connections"]:
			var offset = DIR_NAMES.find(dir)
			var nx = cx + DIRECTIONS[offset][0]
			var ny = cy + DIRECTIONS[offset][1]
			if nx >= 0 and nx < map_width and ny >= 0 and ny < map_height:
				if grid[nx][ny]["type"] != "boss":
					if not [nx, ny] in visited:
						queue.append([nx, ny])
	return false


func _recolor_room(x, y, color):
	for room in get_children():
		if not room.has_meta("grid_x"):
			continue
		if room.get_meta("grid_x") == x and room.get_meta("grid_y") == y:
			room.modulate = color
			break

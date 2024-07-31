extends RayCast2D

@export var max_distance: float = 95  # Maximum range to detect light sources

@onready var shadow = $".."

var nearest_light = null
var player = null
var killed_shadow = false

func _ready():
	enabled = true

func _physics_process(_delta):
	if nearest_light and !killed_shadow:
		update_raycast(nearest_light)
	if killed_shadow:
		killed_shadow = false
		shadow.reset_to_spawnpoint()
	
func _process(delta):
	if !killed_shadow:
		check_collision()
		
func check_collision():
	nearest_light = get_nearest_light()
	if nearest_light:
		var direction = nearest_light.global_position - global_position
		target_position = direction.normalized() * max_distance
	
func update_raycast(nearest_light):
	var distance_to_light = global_position.distance_to(nearest_light.global_position)
	if distance_to_light > max_distance:
		return
	elif is_colliding():
	
		var collider = get_collider()
		if collider is TileMap:
			var pos = get_collision_point()
			var tile_coords = shadow.tile_map.local_to_map(pos)
			var tile_data: TileData = shadow.tile_map.get_cell_tile_data(1, tile_coords)
			if tile_data != null:
				if tile_data.get_custom_data("is_side_wall"):
					add_exception_rid(get_collider_rid())
					force_raycast_update()
				elif tile_data.get_custom_data("light_source"):
					clear_exceptions()
					killed_shadow = true
				else:
					clear_exceptions()
			else:
				tile_data = shadow.tile_map.get_cell_tile_data(0, tile_coords)
				if tile_data != null:
					if tile_data.get_custom_data("is_water"):
						add_exception_rid(get_collider_rid())
						force_raycast_update()
					else:
						add_exception_rid(get_collider_rid())
						force_raycast_update()
	else:
		killed_shadow = true
		

func get_all_lights_in_tree(node):
	var lights = []
				
	if node is PointLight2D:
		if node.has_meta("is_light"):
			var meta = node.get_meta("is_light", null)
			if meta != null and meta:
				lights.append(node)
			
	for child in node.get_children():
		lights += get_all_lights_in_tree(child)

	return lights

func get_nearest_light():
	var nearest_light = null
	var nearest_distance = INF

	# Get all Light2D nodes in the entire scene tree
	var all_lights = get_all_lights_in_tree(get_tree().get_root())
	for light in all_lights:
		var distance = global_position.distance_to(light.global_position)
		if distance < nearest_distance:
			if light.has_meta("max_distance"):
				max_distance = light.get_meta("max_distance")
				if max_distance == 0:
					continue
			nearest_distance = distance
			nearest_light = light
	if nearest_distance < max_distance:
		max_distance = nearest_distance	
	return nearest_light

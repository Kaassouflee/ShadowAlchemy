extends RayCast2D

@export var max_distance: float = 95  # Maximum range to detect light sources

@onready var shadow = $".."

func _ready():
	enabled = true

func _physics_process(delta):
	var nearest_light = get_nearest_light()
	
	if nearest_light:
		var direction = nearest_light.global_position - global_position
		target_position = direction.normalized() * max_distance
		update_raycast(nearest_light)
		#print("Direction: ", direction)
	#else:
		#print("No light source found.")
	
func update_raycast(nearest_light):
	if is_colliding():
		var collider = get_collider()
		if collider is StaticBody2D or collider is TileMap:  # Check if the collider is a StaticBody2D
			pass
		#print("Ray is blocked by: ", collider)
	elif global_position.distance_to(nearest_light.global_position) >= max_distance:
		pass
		#print("Light source is out of range.")
	else:
		shadow.reset_to_spawnpoint()
		#print("Ray is hitting the light source.")

func get_all_lights_in_tree(node):
	var lights = []
	
	if node is Light2D:
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
			nearest_distance = distance
			nearest_light = light

	return nearest_light

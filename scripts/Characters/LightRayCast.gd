extends RayCast2D

@export var max_distance: float = 95  # Maximum range to detect light sources

@onready var shadow = $".."

var player = null
var killed_shadow = false
func _ready():
	enabled = true

func _physics_process(_delta):
	if killed_shadow:
		killed_shadow = false
		shadow.reset_to_spawnpoint()
	
func _process(delta):
	check_collision()
		
func check_collision():
	var nearest_light = get_nearest_light()
	if nearest_light:
		var direction = nearest_light.global_position - global_position
		target_position = direction.normalized() * max_distance
		update_raycast(nearest_light)
	
func update_raycast(nearest_light):
	if global_position.distance_to(nearest_light.global_position) > max_distance:
		return
	if is_colliding():
		var collider = get_collider()
	# Check if the collider is a StaticBody2D
		if collider is TileMap:
			return
	else:
		killed_shadow = true
		

func get_all_lights_in_tree(node):
	var lights = []
	
	if node is Sprite2D:
		if node.has_meta("isLight"):
			var meta = node.get_meta("isLight", null)
			if meta != null and meta:
				lights.append(node)
	if node is AnimatedSprite2D:
		if node.has_meta("isPlayer"):
			var meta = node.get_meta("isPlayer", null)
			if meta != null and meta:
				player = node
				
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
			max_distance = light.get_meta("max_distance")
			if distance < max_distance:
				max_distance = distance
			
	var distance = global_position.distance_to(player.global_position)
	if distance < nearest_distance:
		nearest_distance = distance
		nearest_light = player
		max_distance = player.get_meta("max_distance")
		if distance < max_distance:
				max_distance = distance
	
	return nearest_light

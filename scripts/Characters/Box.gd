extends StaticBody2D

@onready var characters = %Characters
@onready var shadow = $"../../Characters/Shadow"
@onready var ray = $RayCast2D
@onready var tile_map = %TileMap
@onready var sprite = $BoxSprite
@onready var occluder = $LightOccluder2D

var is_possessed = false
var is_moving = false
var is_timing = false
var is_black = true

var last_player_before_death
var movement_direction = ""
var tile_size = 64
var speed = 4

func _physics_process(_delta):
	if !is_moving:
		return
	if global_position == sprite.global_position:
		is_moving = false
		return
	sprite.global_position = await sprite.global_position.move_toward(global_position, speed)
	occluder.global_position = await occluder.global_position.move_toward(global_position, speed)
func _process(_delta):
	if is_moving:
		return
	if is_possessed:
		if (characters.is_player == 2):
			if Input.is_action_pressed("up"):
				movement_direction = "up"
				move(Vector2.UP)
			elif Input.is_action_pressed("down"):
				movement_direction = "down"
				move(Vector2.DOWN)
			elif Input.is_action_pressed("left"):
				movement_direction = "left"
				move(Vector2.LEFT)
			elif Input.is_action_pressed("right"):
				movement_direction = "right"
				move(Vector2.RIGHT)
			elif Input.is_action_just_pressed("trigger"):
				shadow._end_possessing()

func move(direction: Vector2i):
	# Get Current tile Vector2i
	var current_tile: Vector2i = tile_map.local_to_map(global_position)
	# Get target tile Vector2i
	var target_tile: Vector2i = Vector2i(
		current_tile.x + direction.x,
		current_tile.y + direction.y,
	)
	
	ray.target_position = direction * tile_size
	ray.force_raycast_update()
	if ray.is_colliding():
		return
	# Move player
	is_moving = true
	global_position = tile_map.map_to_local(target_tile)
	sprite.global_position = tile_map.map_to_local(current_tile)
	occluder.global_position = tile_map.map_to_local(current_tile)
	

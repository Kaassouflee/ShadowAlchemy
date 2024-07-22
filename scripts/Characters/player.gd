extends Area2D

@onready var tile_map = %TileMap
@onready var animated_sprite = $AnimatedSprite2D
@onready var ray = $RayCast2d
@onready var characters = %Characters

var is_moving = false
var direction = ""
var tile_size = 64

func _physics_process(delta):
	if !is_moving:
		return
	
	if global_position == animated_sprite.global_position:
		is_moving = false
		return
	match direction:
		"up":
			animated_sprite.play("Up")
		"down":
			animated_sprite.play("Down")
		"left":
			animated_sprite.play("Left")
		"right":
			animated_sprite.play("Right")
		_:
			animated_sprite.play("Idle")
	animated_sprite.global_position = animated_sprite.global_position.move_toward(global_position, 4)

func _process(delta):
	if is_moving:
		return
	animated_sprite.stop()
	if (characters.is_turn_player):
		if Input.is_action_pressed("up"):
			direction = "up"
			move(Vector2.UP)
		elif Input.is_action_pressed("down"):
			direction = "down"
			move(Vector2.DOWN)
		elif Input.is_action_pressed("left"):
			direction = "left"
			move(Vector2.LEFT)
		elif Input.is_action_pressed("right"):
			direction = "right"
			move(Vector2.RIGHT)
		

func move(direction: Vector2):
	# Get Current tile Vector2i
	var current_tile: Vector2i = tile_map.local_to_map(global_position)
	# Get target tile Vector2i
	var target_tile: Vector2i = Vector2i(
		current_tile.x + direction.x,
		current_tile.y + direction.y,
	)
	# Get custom data layer from the target tile
	var tile_data: TileData = tile_map.get_cell_tile_data(0, target_tile)
	
	ray.target_position = direction * tile_size
	ray.force_raycast_update()
	if ray.is_colliding():
		return
	# Move player
	is_moving = true
	
	global_position = tile_map.map_to_local(target_tile)
	
	animated_sprite.global_position = tile_map.map_to_local(current_tile)


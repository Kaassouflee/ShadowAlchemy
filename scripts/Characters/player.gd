extends Area2D

@onready var tile_map = %TileMap
@onready var animated_sprite = $AnimatedSprite2D
@onready var characters = %Characters
@onready var sprite_light = $AnimatedSprite2D/SpriteLight
@onready var ray = $RayCast2D
@onready var potion_ray = $PotionRay

var is_moving = false
var movement_direction = ""
var movement_vector
var tile_size = 64

func _physics_process(_delta):
	if !is_moving:
		return
	
	if global_position == animated_sprite.global_position:
		is_moving = false
		return
	match movement_direction:
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

func _process(_delta):
	if is_moving:
		return
	animated_sprite.stop()
	if (characters.is_player == 1):
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
func move(direction: Vector2):
	movement_vector = direction
	# Get Current tile Vector2i
	var current_tile: Vector2i = tile_map.local_to_map(global_position)
	# Get target tile Vector2i
	var target_tile: Vector2i = Vector2i(
		current_tile.x + direction.x,
		current_tile.y + direction.y,
	)
	
	potion_ray.target_position = direction * tile_size
	potion_ray.force_raycast_update()
	ray.target_position = direction * tile_size
	ray.force_raycast_update()

	if ray.is_colliding():
		match movement_direction:
			"up":
				animated_sprite.play("default_up")
			"down":
				animated_sprite.play("default_down")
			"left":
				animated_sprite.play("default_left")
			"right":
				animated_sprite.play("default_right")
		return
	# Move player
	is_moving = true
	global_position = tile_map.map_to_local(target_tile)
	animated_sprite.global_position = tile_map.map_to_local(current_tile)


func _ready():
	sprite_light.set_meta("max_distance", 95)

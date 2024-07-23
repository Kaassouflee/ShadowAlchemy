extends Area2D

@onready var tile_map = %TileMap
@onready var animated_sprite = $ShadowSprite
@onready var characters = %Characters
@onready var spawnpoint = %Spawnpoint
@onready var shadow_death = $ShadowDeath
@onready var timer = $Timer

var is_moving = false
var is_timing = false
var is_black = true
var movement_direction = ""
var tile_size = 64
var last_player_before_death

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
	animated_sprite.global_position = await animated_sprite.global_position.move_toward(global_position, 4)

func _process(_delta):
	if is_moving:
		return
	animated_sprite.stop()
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
		

func move(direction: Vector2i):
	# Get Current tile Vector2i
	var current_tile: Vector2i = tile_map.local_to_map(global_position)
	# Get target tile Vector2i
	var target_tile: Vector2i = Vector2i(
		current_tile.x + direction.x,
		current_tile.y + direction.y,
	)
	
	var tile_data: TileData = tile_map.get_cell_tile_data(0, target_tile)
	
	if !tile_data.get_custom_data("walkable"):
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
	

func reset_to_spawnpoint():
	if !last_player_before_death:
		last_player_before_death = characters.is_player
	print(last_player_before_death)
	# Turn shadow white and back to black
	if is_timing:
		if is_black:
			$ShadowSprite.material.set("shader_param/solid_color", Color.WHITE)
			is_black = false
		else:
			$ShadowSprite.material.set("shader_param/solid_color", Color.BLACK)
			is_black = true
	else:
		shadow_death.play()
		is_timing = true
		timer.wait_time = 1.0
		timer.one_shot = true
		print("Timer started")
		timer.start()
		characters.is_player = 0

func _on_timer_timeout():
	var target_tile: Vector2i = tile_map.local_to_map(spawnpoint.global_position)
	animated_sprite.stop()
	global_position = tile_map.map_to_local(target_tile)
	is_timing = false
	is_black = true
	characters.is_player = last_player_before_death
	last_player_before_death = null
	print("Time has passed")

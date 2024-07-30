extends Area2D

@onready var tile_map = %TileMap
@onready var animated_sprite = $ShadowSprite
@onready var characters = %Characters
@onready var spawnpoint = %Spawnpoint
@onready var shadow_death = $ShadowDeath
@onready var timer = $Timer
@onready var ray = $CollisionRayCast
@onready var label = $ShadowSprite/RichTextLabel

var is_moving = false
var is_timing = false
var is_black = true
var is_possessing = false

var speed = 4
var movement_direction = ""
var tile_size = 64
var last_player_before_death
var possessable_object = null
var possession_particles
var possession_sound

func _physics_process(_delta):
	if !is_moving:
		return
	if global_position == animated_sprite.global_position:
		is_moving = false
		_possessing_check()
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
	animated_sprite.global_position = await animated_sprite.global_position.move_toward(global_position, speed)
	
func _possessing_check():
	var directions = [Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN]
	var current_tile: Vector2i = tile_map.local_to_map(global_position)
	for direction in directions:
		ray.target_position = direction * tile_size
		ray.force_raycast_update()
		if ray.is_colliding():
		# Get target tile Vector2i
			var target_tile: Vector2i = Vector2i(
				current_tile.x + direction.x,
				current_tile.y + direction.y)
			var node = ray.get_collider()
			if node is CollisionObject2D:
				if node.get_meta("possessable"):
					label.visible = true
					possessable_object = node
					possession_particles = possessable_object.get_node("PossessionParticles")
					possession_sound = possessable_object.get_node("PossessionSound")
					return
		label.visible = false
		
func _process(_delta):
	if is_moving or is_possessing:
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
		elif Input.is_action_just_released("trigger"):
			_start_possessing()

func _start_possessing():
	if possessable_object != null:
		possession_particles.emitting = true
		possession_sound.play()
		is_possessing = true
		possessable_object.is_possessed = true
		label.visible = false
		
func _end_possessing():	
	possession_particles.emitting = false
	visible = true
	possessable_object.is_possessed = false
	possessable_object = null
	is_possessing = false
	
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
		var collided = ray.get_collider()
		match movement_direction:
			"up":
				animated_sprite.play("default_up")
			"down":
				animated_sprite.play("default_down")
			"left":
				animated_sprite.play("default_left")
			"right":
				animated_sprite.play("default_right")
		if !collided.has_meta("possessable"):
			return
		if !collided.get_meta("possessable"):		
			return
	# Move player
	is_moving = true
	global_position = tile_map.map_to_local(target_tile)
	animated_sprite.global_position = tile_map.map_to_local(current_tile)

func reset_to_spawnpoint():
	if !last_player_before_death:
		last_player_before_death = characters.is_player
	# Turn shadow white and back to black
	if is_timing:
		if is_black:
			animated_sprite.material.set("shader_param/solid_color", Color.WHITE)
			is_black = false
		else:
			animated_sprite.material.set("shader_param/solid_color", Color.BLACK)
			is_black = true
	else:
		shadow_death.play()
		is_timing = true
		timer.wait_time = 1.0
		timer.one_shot = true
		timer.start()
		characters.is_player = 0
		if (is_possessing):
			_end_possessing()

func _on_timer_timeout():
	var target_tile: Vector2i = tile_map.local_to_map(spawnpoint.global_position)
	animated_sprite.stop()
	global_position = tile_map.map_to_local(target_tile)
	is_timing = false
	is_black = true
	characters.is_player = last_player_before_death
	last_player_before_death = null
	animated_sprite.material.set("shader_param/solid_color", Color.BLACK)


func _on_ready():
	label.visible = false

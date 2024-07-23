extends Node2D
@onready var characters = %Characters
@onready var current_memory = %CurrentMemory
@onready var memory_pickup = %MemoryPickup
@onready var pause_menu = $Camera2D/PauseMenu/CanvasLayer
@onready var memory_item = $MemoryItem
@export var current_level = 1
var is_paused = false
var last_player_before_pause = 1


func _ready():
	characters.is_player = 1
	
func _process(delta):
	if Input.is_action_just_released("pause"):
		pauseMenu()

func pauseMenu():
	if is_paused && !memory_item.is_active_memory:
		pause_menu.show()
		last_player_before_pause = characters.is_player
		characters.is_player = 0
		Engine.time_scale = 0
	else:
		pause_menu.hide()
		characters.is_player = last_player_before_pause
		Engine.time_scale = 1
	
	is_paused = !is_paused

func _draw():
	for x in range(0, 1152, 64):
		draw_line(Vector2(x, 0), Vector2(x, 640), Color8(0, 0, 0), 1.5)
	for y in range(0, 640, 64):
		draw_line(Vector2(0, y), Vector2(1152, y), Color8(0, 0, 0), 2)

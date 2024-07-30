extends Node2D

@onready var tile_map = %TileMap
@onready var characters = %Characters
@onready var pause_menu = $Camera2D/PauseMenu/CanvasLayer
@onready var memory_item = $MemoryItem
@onready var resume_button = $Camera2D/PauseMenu/CanvasLayer/MarginContainer/VBoxContainer/ResumeButton
@export var dcurrent_level = 1
var is_paused = false
var last_player_before_pause = 1

func _ready():
	characters.is_player = 1
	GlobalProgression.current_level = get_tree().current_scene.scene_file_path.get_file().split(".")[0]

func _process(delta):
	if Input.is_action_just_released("pause"):
		pauseMenu()

func pauseMenu():
	if is_paused && !memory_item.is_active_memory:
		resume_button.grab_focus()
		pause_menu.show()
		last_player_before_pause = characters.is_player
		characters.is_player = 0
		Engine.time_scale = 0
	else:
		pause_menu.hide()
		characters.is_player = last_player_before_pause
		Engine.time_scale = 1
	
	is_paused = !is_paused

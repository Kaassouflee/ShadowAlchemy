extends Control

@onready var main_menu = "res://scenes/UI/main_menu.tscn"
@onready var level_selection = "res://scenes/UI/level_select.tscn"
@onready var music = $Music

func _ready():
	music.play()

func _on_main_menu_pressed():
	get_tree().change_scene_to_file(main_menu)

func _on_level_select_pressed():
	get_tree().change_scene_to_file(level_selection)

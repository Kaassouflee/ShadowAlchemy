extends Control

@onready var main_menu = "res://scenes/UI/main_menu.tscn"
@onready var level_selection = "res://scenes/UI/level_select.tscn"
@onready var main_menu_btn = $"CanvasLayer/ColorRect/GridContainer/Main menu"
@onready var level_select_btn = $"CanvasLayer/ColorRect/GridContainer/Level select"
@onready var next_level_btn = $"CanvasLayer/ColorRect/GridContainer/Next level"

func _ready():
	next_level_btn.grab_focus()

func _on_main_menu_pressed():
	get_tree().change_scene_to_file(main_menu)

func _on_level_select_pressed():
	get_tree().change_scene_to_file(level_selection)

func _on_animation_player_animation_finished(anim_name):
	main_menu_btn.disabled = false
	level_select_btn.disabled = false
	next_level_btn.disabled = false

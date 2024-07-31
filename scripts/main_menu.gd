class_name MainMenu
extends Control

@onready var start_button = $MarginContainer/HBoxContainer/VBoxContainer/StartButton as Button
@onready var exit_button = $MarginContainer/HBoxContainer/VBoxContainer/ExitButton as Button
@onready var level_select_button = $MarginContainer/HBoxContainer/VBoxContainer/LevelSelectButton as Button
@onready var start_level = "res://scenes/levels/level_1.tscn"
@onready var level_selection = "res://scenes/UI/level_select.tscn"

func _ready():
	start_button.button_down.connect(on_start_pressed)
	exit_button.button_down.connect(on_exit_pressed)
	start_button.grab_focus()

func on_start_pressed() -> void:
	get_tree().change_scene_to_file(start_level)

func _on_level_select_button_pressed():
	get_tree().change_scene_to_file(level_selection)

func on_exit_pressed() -> void:
	get_tree().quit()

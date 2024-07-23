class_name MainMenu
extends Control

@onready var start_button = $MarginContainer/HBoxContainer/VBoxContainer/StartButton as Button
@onready var exit_button = $MarginContainer/HBoxContainer/VBoxContainer/ExitButton as Button
@onready var level_select_button = $MarginContainer/HBoxContainer/VBoxContainer/LevelSelectButton as Button
@onready var start_level = "res://scenes/levels/main.tscn"

#TODO: add functionality for the level select button

func _ready():
	start_button.button_down.connect(on_start_pressed)
	exit_button.button_down.connect(on_exit_pressed)

func on_start_pressed() -> void:
	get_tree().change_scene_to_file(start_level)

func on_exit_pressed() -> void:
	get_tree().quit()

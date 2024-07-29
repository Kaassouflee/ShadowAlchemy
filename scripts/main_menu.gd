class_name MainMenu
extends Control

@onready var start_button = $MarginContainer/HBoxContainer/VBoxContainer/StartButton as Button
@onready var exit_button = $MarginContainer/HBoxContainer/VBoxContainer/ExitButton as Button
@onready var level_select_button = $MarginContainer/HBoxContainer/VBoxContainer/LevelSelectButton as Button
@onready var options_button = $MarginContainer/HBoxContainer/VBoxContainer/OptionsButton as Button
@onready var margin_container = $MarginContainer as MarginContainer
@onready var options_menu = $options_menu as OptionsMenu
@onready var start_level = "res://scenes/levels/main.tscn"
@onready var level_selection = "res://scenes/UI/level_select.tscn"

func _ready():
	handle_connection_signals()

func handle_connection_signals():
	start_button.button_down.connect(on_start_pressed)
	level_select_button.button_down.connect(on_level_select_button_pressed)
	exit_button.button_down.connect(on_exit_pressed)
	options_button.button_down.connect(on_options_button_pressed)
	options_menu.exit_options_menu.connect(on_exit_options_menu)
	start_button.grab_focus()

func on_start_pressed() -> void:
	get_tree().change_scene_to_file(start_level)

func on_level_select_button_pressed() -> void:
	get_tree().change_scene_to_file(level_selection)

func on_options_button_pressed() -> void:
	margin_container.visible = false
	options_menu.set_process(true)
	options_menu.visible = true

func on_exit_pressed() -> void:
	get_tree().quit()

func on_exit_options_menu() -> void:
	margin_container.visible = true
	options_menu.visible = false

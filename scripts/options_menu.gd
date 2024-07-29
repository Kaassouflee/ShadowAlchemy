class_name OptionsMenu
extends Control

@onready var back_to_main_menu_button = $MarginContainer/VBoxContainer/BackToMainMenuButton

# For returning to the main menu
signal exit_options_menu

func _ready():
	back_to_main_menu_button.button_down.connect(on_back_to_main_menu_button_pressed)
	set_process(false)

func on_back_to_main_menu_button_pressed() -> void:
	exit_options_menu.emit()
	set_process(false)

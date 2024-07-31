extends Control

@onready var main = $"../../"
@onready var main_menu = "res://scenes/UI/main_menu.tscn"

func _on_resume_pressed():
	main.pauseMenu()
	
func _on_restart_button_pressed():
	get_tree().reload_current_scene()
	Engine.time_scale = 1
	
func _on_main_menu_pressed():
	Engine.time_scale = 1
	get_tree().change_scene_to_file(main_menu)

func _on_quit_pressed():
	get_tree().quit()

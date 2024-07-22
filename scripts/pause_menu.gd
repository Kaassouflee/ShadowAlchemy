extends Control

@onready var main = $"../../"

func _on_resume_pressed():
	main.pauseMenu()

#TODO: add main menu functionality
func _on_main_menu_pressed():
	pass # Replace with function body.

func _on_quit_pressed():
	get_tree().quit()

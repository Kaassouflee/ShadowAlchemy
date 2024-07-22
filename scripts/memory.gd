extends Control

@onready var main_menu = "res://scenes/UI/main_menu.tscn"

func _on_main_menu_pressed():
	var MemoryUI = get_tree().root.get_node("Memory")
	get_tree().change_scene_to_file(main_menu)
	get_tree().root.remove_child(MemoryUI)

#TODO: add level select functionality
func _on_level_select_pressed():
	pass # Replace with function body.

#TODO: add next level functionality
func _on_next_level_pressed():
	pass # Replace with function body.

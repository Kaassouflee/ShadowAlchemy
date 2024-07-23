extends Control
@onready var next_level = $"CanvasLayer/ColorRect/GridContainer/Next level"

@onready var main_menu = "res://scenes/UI/main_menu.tscn"
var MemoryUI
var current_memory

func _ready():
	current_memory = get_tree().root.get_node("Level/LevelMemory")
	MemoryUI = get_tree().root.get_node("Memory")
	if !current_memory || !current_memory.memory || current_memory.memory["next_level"] == "":
		next_level.disabled = true
		next_level.text = "The End"
	else:
		next_level.disabled = false
		next_level.text = "Next level"
	
func _on_main_menu_pressed():
	get_tree().change_scene_to_file(main_menu)
	get_tree().root.remove_child(MemoryUI)

#TODO: add level select functionality
func _on_level_select_pressed():
	pass # Replace with function body.

func _on_next_level_pressed():
	print("res://scenes/levels/" + current_memory.memory["next_level"])
	get_tree().change_scene_to_file("res://scenes/levels/" + current_memory.memory["next_level"] + ".tscn")
	get_tree().root.remove_child(MemoryUI)
	

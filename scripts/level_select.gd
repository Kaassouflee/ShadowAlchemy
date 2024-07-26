extends Control

const LEVEL_BTN = preload("res://assets/level_button.tscn")
@onready var grid = $MarginContainer/VBoxContainer/GridContainer
@onready var main_menu = "res://scenes/UI/main_menu.tscn"

# All the excisting levels in the game
var levels = {
	0: "main",
	1: "level_2"
}

func _ready():
	get_levels()

func get_levels()->void:
	var last_level_beat = GlobalProgression.last_level_beat
	var last_level_index = -1
	
	if last_level_beat !="":
		for index in levels.keys():
			if levels[index] == last_level_beat:
				last_level_index = index
				break
	else:
		last_level_index = -1
	
	for index in levels.keys():
		var level_path = "res://scenes/levels/" + levels[index] + ".tscn"
		var is_unlocked = index <=last_level_index + 1
		create_lvl_button(level_path, index, levels[index], is_unlocked)

func create_lvl_button(lvl_path: String, index: int, level: String, is_unlocked: bool):
	var btn = LEVEL_BTN.instantiate()
	btn.level_path = lvl_path
	
	if is_unlocked:
		var label = btn.get_node("Label")
		if label:
			label.text = str(index + 1)
	else:
		btn.disabled = true
	
	grid.add_child(btn)

func _on_back_to_main_menu_button_pressed():
	get_tree().change_scene_to_file(main_menu)

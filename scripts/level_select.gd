extends Control

const LEVEL_BTN = preload("res://assets/level_button.tscn")
@onready var grid = $MarginContainer/VBoxContainer/GridContainer
@onready var main_menu = "res://scenes/UI/main_menu.tscn"
@onready var back_to_main_menu_button = $BackToMainMenuButton

# All the existing levels in the game
var levels = {
	0: "main",
	1: "level_2"
}

func _ready():
	back_to_main_menu_button.grab_focus()
	get_levels()
	set_button_focus_neighbors()

func get_levels() -> void:
	var last_level_beat = GlobalProgression.last_level_beat
	var last_level_index = -1
	
	if last_level_beat != "":
		for index in levels.keys():
			if levels[index] == last_level_beat:
				last_level_index = index
				break
	else:
		last_level_index = -1
	
	for index in levels.keys():
		var level_path = "res://scenes/levels/" + levels[index] + ".tscn"
		var is_unlocked = index <= last_level_index + 1
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

func set_button_focus_neighbors():
	var children = grid.get_children()
	for i in range(children.size()):
		var btn = children[i]
		if btn is Button:
			if i == 0:
				btn.focus_neighbor_left = back_to_main_menu_button
				back_to_main_menu_button.focus_neighbor_right = children[i]
			if i > 0:
				btn.focus_neighbor_left = children[i - 1]
				children[i - 1].focus_neighbor_right = btn
			if i >= grid.columns:
				btn.focus_neighbor_top = children[i - grid.columns]
				children[i - grid.columns].focus_neighbor_bottom = btn
				
	#if children.size() > 0:
		#var child = children[0]
		#if child is Control:
			#child.focus_neighbor_top = back_to_main_menu_button
		#else:
			#print("Error: child is not a Control")


func _on_back_to_main_menu_button_pressed():
	get_tree().change_scene_to_file(main_menu)

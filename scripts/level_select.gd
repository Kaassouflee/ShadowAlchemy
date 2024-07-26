extends Control

const LEVEL_BTN = preload("res://assets/level_button.tscn")
@onready var grid = $MarginContainer/VBoxContainer/GridContainer

var levels = {
	0: "main",
	1: "level_2"
}

#TODO: add locked levels functionality
func _ready():
	get_levels()

func get_levels() ->void:
	var index = 1
	for level in levels:
		var level_path = "res://scenes/levels/" + levels[level] + ".tscn"
		create_lvl_button(level_path, index)
		index += 1

func create_lvl_button(lvl_path: String, index):
	var btn = LEVEL_BTN.instantiate()
	btn.level_path = lvl_path
	var label = btn.get_node("Label")
	if label:
		label.text = str(index)
	grid.add_child(btn)
	

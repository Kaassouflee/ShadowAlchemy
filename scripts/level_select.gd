extends Control

const LEVEL_BTN = preload("res://assets/level_button.tscn")
@onready var grid = $MarginContainer/VBoxContainer/GridContainer
var is_locked = false

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
		print("Level number " + str(level))
		var level_path = "res://scenes/levels/" + levels[level] + ".tscn"
		create_lvl_button(level_path, index, levels[level])
		index += 1

func create_lvl_button(lvl_path: String, index, level):
	var btn = LEVEL_BTN.instantiate()
	btn.level_path = lvl_path
	if level == GlobalProgression.last_level_beat:
		is_locked = true
	
	if !is_locked:
		var label = btn.get_node("Label")
		if label:
			label.text = str(index)
	else:
		btn.disabled = true
	grid.add_child(btn)
	

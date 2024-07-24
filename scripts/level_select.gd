extends Control

const LEVEL_BTN = preload("res://assets/level_button.tscn")
@export_dir var dir_path
@onready var grid = $MarginContainer/VBoxContainer/GridContainer

func _ready():
	get_levels(dir_path)

func get_levels(path) ->void:
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		var index = 1
		
		while file_name != "":
			if file_name.ends_with(".tscn"):
				create_lvl_button('%s/%s' % [dir.get_current_dir(), file_name], file_name, index)
				index +=1
			file_name =dir.get_next()
		dir.list_dir_end()
	else:
		print("An error has occured when trying to access the level path")

func create_lvl_button(lvl_path: String, lvl_name: String, index):
	var btn = LEVEL_BTN.instantiate()
	btn.level_path = lvl_path
	var label = btn.get_node("Label")
	if label:
		label.text = str(index)
	grid.add_child(btn)
	

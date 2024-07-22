extends Node2D
var MemoryUI = preload("res://scenes/UI/memory.tscn")
@onready var characters = %Characters
@onready var current_memory = %CurrentMemory
@onready var memory_pickup = %MemoryPickup

func _draw():
	for x in range(0, 1152, 64):
		draw_line(Vector2(x, 0), Vector2(x, 640), Color8(0, 0, 0), 1.5)
	for y in range(0, 640, 64):
		draw_line(Vector2(0, y), Vector2(1152, y), Color8(0, 0, 0), 2)


# Opening memory ui and configuring it based on the CurrentMemory in this scene
func _on_area_2d_area_entered(area):
	memory_pickup.play()
	var memoryUi = MemoryUI.instantiate()
	get_tree().root.add_child(memoryUi)
	var base = memoryUi.get_node("CanvasLayer/ColorRect/VBoxContainer")
	
	# Image
	var image = load("res://assets/memories/" + current_memory.memory["image"] + ".png")
	var memory_image = base.get_node("MemoryImage")
	memory_image.texture = image
	
	# Title
	var memory_title = base.get_node("MemoryTitle")
	memory_title.text = current_memory.memory["title"]
	
	# Text
	var memory_text = base.get_node("MemoryText")
	memory_text.text = current_memory.memory["text"]
	
	# TODO: add next level button that works and points to the next level

	characters.is_player = 0
	

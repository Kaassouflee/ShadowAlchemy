extends Sprite2D

@onready var memory_pickup = %MemoryPickup
@export var is_active_memory = false
var MemoryUI = preload("res://scenes/UI/memory.tscn")

func _on_area_2d_area_entered(area):
	var characters = get_tree().root.get_node("Level/Characters")
	if characters.is_player == 1:
		var current_memory = get_tree().root.get_node("Level/LevelMemory")
		memory_pickup.play()
		characters.is_player = 0
		is_active_memory = true
		
		var memoryUi = MemoryUI.instantiate()
		get_tree().root.add_child(memoryUi)
		var base = memoryUi.get_node("CanvasLayer/ColorRect")
		
		if !current_memory || !current_memory.memory:
			base.get_node("VBoxContainer/MemoryTitle").text = "Coming soon"
			base.get_node("VBoxContainer/MemoryText").text = "Coming soon"
		else:
			# Image
			base.get_node("VBoxContainer/MemoryImage").texture = load("res://assets/memories/" + current_memory.memory["image"] + ".png")
			# Title
			base.get_node("VBoxContainer/MemoryTitle").text = current_memory.memory["title"]
			# Text
			base.get_node("VBoxContainer/MemoryText").text = current_memory.memory["text"]

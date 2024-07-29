extends Sprite2D

@onready var memory_pickup = %MemoryPickup
@onready var player = $"../Characters/Player"
@export var is_active_memory = false
var MemoryUI = preload("res://scenes/UI/memory.tscn")
var picked_up_players = {}
var characters

func _ready():
	characters = get_tree().root.get_node("Level/Characters")

func _on_area_2d_area_entered(area):
	if characters.is_player == 1 or characters.is_player == 2:
		picked_up_players[characters.is_player] = true
	update_player_count()

func _on_area_2d_area_exited(area):
	if characters.is_player == 1 or characters.is_player == 2:
		picked_up_players.erase(characters.is_player)
	update_player_count()

func update_player_count():
	if picked_up_players.size() == 1:
		if 1 in picked_up_players:
			player.get_node("AnimatedSprite2D/SpriteLight").set_meta("max_distance", 0)
			player.get_node("AnimatedSprite2D/SpriteLight").enabled = false
			player.get_node("AnimatedSprite2D/ShadowLight").enabled = false
	elif picked_up_players.size() == 2:
		GlobalProgression.last_level_beat = GlobalProgression.current_level
		var current_memory = get_tree().root.get_node("Level/LevelMemory")
		memory_pickup.play()
		characters.is_player = 0
		is_active_memory = true

		var memoryUi = MemoryUI.instantiate()
		get_tree().root.add_child(memoryUi)
		var base = memoryUi.get_node("CanvasLayer/ColorRect")

		if !current_memory or !current_memory.memory:
			base.get_node("VBoxContainer/MemoryTitle").text = "Coming soon"
			base.get_node("VBoxContainer/MemoryText").text = "Coming soon"
		else:
			# Image
			base.get_node("VBoxContainer/MemoryImage").texture = load("res://assets/memories/" + current_memory.memory["image"] + ".png")
			# Title
			base.get_node("VBoxContainer/MemoryTitle").text = current_memory.memory["title"]
			# Text
			base.get_node("VBoxContainer/MemoryText").text = current_memory.memory["text"]
	else:
		# Re-enable player lights if both are not in the area
		player.get_node("AnimatedSprite2D/SpriteLight").set_meta("max_distance", 95)
		player.get_node("AnimatedSprite2D/SpriteLight").enabled = true
		player.get_node("AnimatedSprite2D/ShadowLight").enabled = true

extends Sprite2D

@onready var memory_pickup = %MemoryPickup
@onready var player = $"../Characters/Player"
@export var is_active_memory = false
var picked_up_players = {}
var characters
var current_memory

func _ready():
	characters = get_tree().root.get_node("Level/Characters")
	if current_memory:
		current_memory.queue_free()

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
		if !GlobalProgression.current_level || !GlobalProgression.last_level_beat:
			GlobalProgression.last_level_beat = GlobalProgression.current_level
		elif GlobalProgression.last_level_beat.split("_")[1].to_int() < GlobalProgression.current_level.split("_")[1].to_int():
			GlobalProgression.last_level_beat = GlobalProgression.current_level
		current_memory = get_tree().root.get_node("Level/LevelMemory")
		memory_pickup.play()
		characters.is_player = 0
		is_active_memory = true

		var memoryUi = load("res://scenes/UI/memory.tscn").instantiate()
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
		picked_up_players.clear()
	else:
		# Re-enable player lights if both are not in the area
		player.get_node("AnimatedSprite2D/SpriteLight").set_meta("max_distance", 95)
		player.get_node("AnimatedSprite2D/SpriteLight").enabled = true
		player.get_node("AnimatedSprite2D/ShadowLight").enabled = true

extends TextureButton

@export_file var level_path
@onready var level_button = $"."

func _on_pressed() -> void:
	if level_path != "":
		get_tree().change_scene_to_file(level_path)

func _on_mouse_entered() -> void:
	var label = get_node("Label")
	if label:
		label.hide()
	if level_button.disabled == false:
		level_button.texture_normal = load("res://assets/UI/PlayButton.png")

func _on_mouse_exited() -> void:
	var label = get_node("Label")
	if label:
		label.show()
	if level_button.disabled == false:
		level_button.texture_normal = load("res://assets/UI/EmptyButton.png")

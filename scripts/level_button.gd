extends TextureButton

@export_file var level_path

func _ready():
	# Connect signals to methods
	connect("pressed", Callable(self, "_on_pressed"))
	connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	connect("mouse_exited", Callable(self, "_on_mouse_exited"))

func _on_pressed() -> void:
	if level_path != "":
		get_tree().change_scene_to_file(level_path)

func _on_mouse_entered() -> void:
	var label = get_node("Label")
	if label:
		label.hide()

func _on_mouse_exited() -> void:
	var label = get_node("Label")
	if label:
		label.show()

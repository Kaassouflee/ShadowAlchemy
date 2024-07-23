extends RichTextLabel

var tween: Tween
func _ready():
	tween = create_tween()
	tween.tween_property(self, "visible_ratio", 1.0, 10.0).from(0.0)


func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			tween.set_speed_scale(10)

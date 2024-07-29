extends Sprite2D
@onready var sign = $"."
var label
var richLabel

func _ready():
	if sign.has_node("Label"):
		label = sign.get_node("Label")
	if sign.has_node("RichTextLabel"):
		richLabel = sign.get_node("RichTextLabel")
	
func _on_area_2d_area_entered(area):
	if label:
		label.visible = true
	if richLabel:
		richLabel.visible = true

func _on_area_2d_area_exited(area):
	if label:
		label.visible = false
	if richLabel:
		richLabel.visible = false

extends Node

var is_turn_player = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_released("trigger"):
		print("1: " + str(is_turn_player))
		is_turn_player = !is_turn_player
		print("2: " + str(is_turn_player))

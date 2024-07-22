extends Node

@export var is_turn_player = 1 # Start as character

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_released("trigger"):
		if is_turn_player == 1: # Switch to shadow
			is_turn_player = 2
		elif is_turn_player == 2: # Switch to character
			is_turn_player = 1
		else: 
			is_turn_player = 0 # Stop all movement

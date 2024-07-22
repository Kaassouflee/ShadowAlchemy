extends Area2D

var animation_speed = 4
var moving = false
var tile_size = 64
var inputs = {
	"right": Vector2.RIGHT,
	"left": Vector2.LEFT,
	"up": Vector2.UP,
	"down": Vector2.DOWN
}

@onready var characters = %Characters
@onready var ray = $RayCast2d

func _ready():
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size / 2
	
func _unhandled_input(event):
	if moving:
		return
	for dir in inputs.keys():
		if event.is_action(dir):
			if characters.is_turn_player == 2:
				move(dir)
			
func move(dir):
	ray.target_position = inputs[dir] * tile_size
	ray.force_raycast_update()
	if !ray.is_colliding():
		#position += inputs[dir] * tile_size
		var tween = get_tree().create_tween()
		tween.tween_property(self, "position", position + inputs[dir] * tile_size, 1.0/animation_speed).set_trans(Tween.TRANS_LINEAR)
		moving = true
		$AnimationPlayer.play(dir)
		await tween.finished
		moving = false

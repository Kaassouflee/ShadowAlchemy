extends Node2D

@onready var shadow_light = $LightSprite/ShadowLight
@onready var sprite_light = $LightSprite/SpriteLight
@onready var light_sprite = $LightSprite

var _max_distance = 96

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_radius(tile_range):
	var tilesize = 64
	var distance = tilesize * tile_range + (tilesize / 2 - 1)
	_max_distance = sqrt(distance * distance * 2)
	sprite_light.set_meta("max_distance", _max_distance)
	var scale = distance / 96.0
	var transform = shadow_light.transform
	shadow_light.transform = transform.scaled(Vector2(scale, scale))

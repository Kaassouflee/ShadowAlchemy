extends Node

@onready var light = $Light
@onready var light_2 = $Light2
@onready var light_3 = $Light3
@onready var light_4 = $Light4
@onready var light_5 = $Light5
@onready var light_6 = $Light6

# Called when the node enters the scene tree for the first time.
func _ready():
	light.update_radius(1)
	light_2.update_radius(1)
	light_3.update_radius(1)
	light_4.update_radius(1)
	light_5.update_radius(1)
	light_6.update_radius(1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
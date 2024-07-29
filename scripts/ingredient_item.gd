extends Sprite2D

@onready var ingredient_item = $"."
@onready var ingredient_pickup = $Area2D/IngredientPickup
@onready var collision_shape_2d = $Area2D/CollisionShape2D
@onready var characters = %Characters

var ingredients_list
var potion_logic
var picked_up = false

func _ready():
	potion_logic = get_tree().root.get_node("Level/PotionLogic")
	ingredients_list = get_tree().root.get_node("Level/PotionUI/CanvasLayer/ItemListBackground/ItemList")

func _process(delta):
	if picked_up:
		collision_shape_2d.disabled = true	
		picked_up = false
		self.hide()

func _on_area_2d_area_entered(area):
	if characters.is_player == 1:
		picked_up = true
		ingredient_pickup.play()
		
		var ingredient_icon = ingredient_item.texture.diffuse_texture.get_load_path()
		var ingredient_name = get_ingredient_name(ingredient_icon)
		
		ingredients_list.add_icon_item(load(ingredient_icon))
		potion_logic.picked_up_ingredients.append(ingredient_name)

		# Sets tooltip 
		var count = potion_logic.picked_up_ingredients.size() - 1
		if count == -1:
			count = 0
		ingredients_list.set_item_tooltip(count, ingredient_name)
	
func get_ingredient_name(path: String) -> String:
	var start = path.rfind("/")
	var end = path.find(".png")
	
	if start == -1 or end == -1:
		return ""
	return path.substr(start + 1, end - start - 1)

func _on_ingredient_pickup_finished():
	self.queue_free()

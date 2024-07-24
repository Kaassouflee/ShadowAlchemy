extends Sprite2D

@onready var ingredient_pickup = $Area2D/IngredientPickup
@onready var ingredient_item = $"."
var potion_logic

func _ready():
	potion_logic = get_tree().root.get_node("Level/PotionLogic")

func _on_area_2d_area_entered(area):
	var ingredient_icon = ingredient_item.texture.diffuse_texture.get_load_path()
	var ingredients_list = get_tree().root.get_node("Level/PotionUI/CanvasLayer/ItemList")
	
	ingredients_list.add_icon_item(load(ingredient_icon))
	potion_logic.picked_up_ingredients.append(get_ingredient_name(ingredient_icon))
	print(potion_logic.picked_up_ingredients)
	
func get_ingredient_name(path: String) -> String:
	var start = path.rfind("/")
	var end = path.find(".png")
	
	if start == -1 or end == -1:
		return ""
	return path.substr(start + 1, end - start - 1)

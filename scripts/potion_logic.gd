extends Node2D

var picked_up_ingredients = []
var potion = null
# Dictionary to map ingredient combinations to potion types
var potion_recipes = {
	"berry_herb_fireflower": {"name": "Fire Potion", "effect": "fire"},
	"berry_herb_iceflower": {"name": "Ice Potion", "effect": "freeze"},
	"flower_herb_berry": {"name": "Darkness Potion", "effect": "darkness"},
	"herb_mushroom_teleportflower": {"name": "Teleportation Potion", "effect": "teleport"},
	"mushroom_flower_growth": {"name": "Growth Potion", "effect": "grow_plants"},
	"berry_mushroom_shrinkflower": {"name": "Shrink Potion", "effect": "shrink"},
	"herb_flower_invisibility": {"name": "Invisibility Potion", "effect": "become_invisible"},
}

func _process(delta):
	if picked_up_ingredients.size() == 3:
		craftPotion()
	if potion:
		if Input.is_action_just_pressed("trigger"):
			usePotion(potion["effect"])

# Gets the array and combines them to check them against the recipes
func get_combination():
	picked_up_ingredients = ["berry", "herb", "mushroom"]
	print(picked_up_ingredients)
	var combination = ""
	for i in range(picked_up_ingredients.size()):
		combination += picked_up_ingredients[i]
		if i < picked_up_ingredients.size() - 1:
			combination += "_"
	return combination

func craftPotion():
	var combination = get_combination()
	if potion_recipes.has(combination):
		var potion_name = potion_recipes[combination]
		print("Crafted potion: " + potion_name)
		picked_up_ingredients.clear()
	else:
		print("No known recipe for this combination of ingredients.")

func usePotion(effect: String):
	match effect:
		"freeze":
			freeze()
		"fire":
			fire()
		"darkness":
			darkness()
		_:
			print("Unknown effect")

func freeze():
	pass
func fire():
	pass
func darkness():
	pass

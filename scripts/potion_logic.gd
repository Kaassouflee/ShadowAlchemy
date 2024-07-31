extends Node2D

# Dictionary to map ingredient combinations to potion types
var potion_recipes = {
	"berry_herb_fireflower": {"name": "Fire Potion", "effect": "fire", "needs_collision": true},
	"berry_herb_iceflower": {"name": "Ice Potion", "effect": "freeze", "needs_collision": true},
	"flower_herb_berry": {"name": "Wall Potion", "effect": "wall", "needs_collision": false},
	"berry_herb_mushroom": {"name": "Darkness Potion", "effect": "darkness", "needs_collision": true},
}
@onready var player = $"../Characters/Player"
@onready var recipe_label = $"../Characters/Player/AnimatedSprite2D/RecipeLabel"
@onready var potion_raycast = $"../Characters/Player/PotionRay"
@onready var tilemap = %TileMap
@onready var characters = %Characters

var particles: PackedScene = preload("res://scenes/potion_particles.tscn")

var picked_up_ingredients = []
var potion = null
var ingredients_list
var potion_list
var used_potion
var crafted_potion
var cell_position
var target
var usage_count = 0

func _ready():
	ingredients_list = get_tree().root.get_node("Level/PotionUI/CanvasLayer/ItemListBackground/ItemList")
	potion_list = get_tree().root.get_node("Level/PotionUI/CanvasLayer/PotionListBackground/PotionList")
	used_potion = get_tree().root.get_node("Level/PotionUI/UsePotion")
	crafted_potion = get_tree().root.get_node("Level/PotionUI/CraftPotion")

func _process(delta):
	if picked_up_ingredients.size() == 3:
		craft_potion()
	if potion && Input.is_action_just_released("trigger") && usage_count == 0 && characters.is_player == 1:
		use_potion(potion_recipes[get_key_by_name(potion)]["effect"])

# Gets potion key based on name
func get_key_by_name(potion_name: String) -> String:
	for key in potion_recipes.keys():
		if potion_recipes[key]["name"] == potion_name:
			return key
	return "Potion not found"
	
# Gets the array and combines them to check them against the recipes
func get_combination():
	var combination = ""
	# Loops through picked up ingredients and adds them to string
	for i in range(picked_up_ingredients.size()):
		combination += picked_up_ingredients[i]
		# Puts a underscore between every ingredient except last one
		if i < picked_up_ingredients.size() - 1:
			combination += "_"
	return combination

# Crafts potion based on the recipes
func craft_potion():
	var combination = get_combination()
	if potion_recipes.has(combination):
		crafted_potion.play()
		var new_potion = potion_recipes[combination]["name"]
		ingredients_list.clear()
		picked_up_ingredients.clear()
		potion_list.add_item(new_potion, load("res://assets/alchemy/potions/potion.png"), false)
		potion_list.set_item_tooltip(0, new_potion)
		if potion_list.item_count == 1:
			potion = new_potion
	else:
		recipe_label.show()
		
# Set metadata for a specific cell
func set_tile_metadata(key: String, value: Variant):
	target = potion_raycast.get_collider()
	if target:
		target.set_meta(key, value)
	else:
		#TODO: Show it somewhere
		print("Invalid tile cell position")

func needs_colliding(potion):
	return potion_raycast.is_colliding() && potion_recipes[get_key_by_name(potion)]["needs_collision"]

func clear_potion():
	if usage_count > 0:
		potion_list.remove_item(0)
		if potion_list.item_count > 0:
			potion = potion_list.get_item_text(0)
		else:	
			potion = null
	usage_count = 0
	
func use_potion(effect: String):
	match effect:
		"freeze":
			if needs_colliding(potion):
				freeze(effect)
		"fire":
			if needs_colliding(potion):
				fire(effect)
		"darkness":
			if needs_colliding(potion):
				darkness(effect)
		"wall":
			if !needs_colliding(potion):
				wall(effect)
		_:
			print("Unknown effect")

func freeze(effect):
	usage_count =+ 1
	used_potion.play()
	set_tile_metadata("has_potion", effect)
	clear_potion()
	
func fire(effect):
	usage_count =+ 1
	used_potion.play()
	set_tile_metadata("has_potion", effect)
	clear_potion()
	
func darkness(effect):
	usage_count =+ 1
	used_potion.play()
	set_tile_metadata("has_potion", effect)
	if target.get_meta("has_potion") && usage_count == 1:
		if target.find_parent("LightSprite"):
			# Add particles
			var particles_inst = particles.instantiate()
			particles_inst.emitting = true
			target.get_parent().get_node("SpriteLight").add_child(particles_inst)
			# Removes lightParticles
			target.get_parent().get_parent().get_node("LightParticles").queue_free()
			#Turn off lights
			target.get_parent().get_node("SpriteLight").set_meta("max_distance", 0)
			target.get_parent().get_node("SpriteLight").enabled = false
			target.get_parent().get_node("ShadowLight").enabled = false
			clear_potion()
	
func wall(effect):	
	usage_count =+ 1
	used_potion.play()
	#TODO: maybe look at what locations are valid? No placing in walls, but I guess it's the player's responsibilty
	#TODO: find a way to place particles on the ground
	if !potion_raycast.get_collider():
		var current_tile: Vector2i = tilemap.local_to_map(player.global_position)
		# Get target tile Vector2i
		var direction = player.movement_vector
		var target_tile: Vector2i = Vector2i(
			current_tile.x + direction.x,
			current_tile.y + direction.y,
		)
		# Gets coordinates and places wall
		var target = tilemap.map_to_local(target_tile)
		tilemap.set_cell(1, Vector2i(target_tile), 0, Vector2i(1, 4))
		tilemap.erase_cell(0, Vector2i(target_tile))
		clear_potion()

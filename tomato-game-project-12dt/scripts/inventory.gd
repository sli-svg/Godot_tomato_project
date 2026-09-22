extends Control

@export var player: CharacterBody2D

@onready var base_button: TextureButton = $Panel/HBoxContainer/TextureButton
@onready var base_quantity_label: Label = $Panel/HBoxContainer/TextureButton/quantity_label
@onready var mutated_button: TextureButton = $Panel/HBoxContainer/TextureButton2
@onready var mutated_quantity_label: Label = $Panel/HBoxContainer/TextureButton2/quantity_label2
@onready var shovel_button: TextureButton = $Panel/HBoxContainer/TextureButton3


var hotbar = [
	"gun",
	"nuke",
	"shovel",
	"base_tomato",
	"mutated_tomato"
]

var items = {
	"gun" : {
		"name" : "Gun",
		"category" : "Weapon",
		"stackable" : false,
		"quantity" : 1
	},
	"nuke" : {
		"name" : "Nuke",
		"category" : "Weapon",
		"stackable" : false,
		"quantity" : 1
	},
	"shovel" : {
		"name" : "Shovel",
		"category" : "Tool",
		"stackable" : false,
		"quantity" : 1
	},
	"base_tomato" : {
		"name" : "Tomato Seed",
		"category" : "Seed",
		"stackable" : true,
		"quantity" : 100
	},
	"mutated_tomato" : {
		"name" : "Mutated Tomato Seed",
		"category" : "Seed",
		"stackable" : true,
		"quantity" : 100
	}
}


#other half of code for 
func _ready() -> void:
	print("INVENTORY LOADED")
	base_button.pressed.connect(_on_base_tomato_pressed)
	mutated_button.pressed.connect(_on_mutated_tomato_pressed)
	
	player = get_tree().current_scene.get_node("Player")
	
	player.seed_planted.connect(_on_seed_planted)
	player.tomato_harvested.connect(_on_tomato_harvested)
	
	update_quantity_labels()


func _on_base_tomato_pressed() -> void:
	print("BASE TOMATO BUTTON PRESSED")
	
	player.select_base_tomato()
	
	#Highlight base tomato button
	base_button.modulate = Color(1.5, 1.5, 1.5)
	
	#Undo highlight on mutated tomato button
	mutated_button.modulate = Color.WHITE
	
	print("PLAYER REFERENCE:", player)
	print("SELECTED SEED:", player.selected_seed)

	base_button.button_pressed = true
	mutated_button.button_pressed = false


func _on_mutated_tomato_pressed() -> void:
	print("MUTATED TOMATO BUTTON PRESSED")
	
	player.select_mutated_tomato()
	
	#Highlight mutated tomato button
	mutated_button.modulate = Color(1.5, 1.5, 1.5)
	
	#Undo highlight on base tomato button
	base_button.modulate = Color.WHITE
	
	print("PLAYER REFERENCE:", player)
	print("SELECTED SEED:", player.selected_seed)

	base_button.button_pressed = false
	mutated_button.button_pressed = true


func _on_seed_planted(seed_id: String) -> void:
	items[seed_id]["quantity"] -= 1
	update_quantity_labels()


func update_quantity_labels() -> void:
	for item_id in items:
		if item_id == "base_tomato":
			base_quantity_label.text = str(items["base_tomato"]["quantity"])
		elif item_id == "mutated_tomato":
			mutated_quantity_label.text = str(items["mutated_tomato"]["quantity"])


func _on_tomato_harvested(tomato_id: String) -> void:
	items[tomato_id]["quantity"] += 3
	update_quantity_labels()
	
	print("Added 3 ", tomato_id, " seeds")
	print("Harvested:", tomato_id)
	print("New quantity:", items[tomato_id]["quantity"])


func _on_shovel_pressed() -> void:
	print("SHOVEL BUTTON PRESSED")
	player.select_shovel()
	
	# Highlight shovel
	shovel_button.modulate = Color(1.5, 1.5, 1.5)
	
	# Unhighlight seeds
	base_button.modulate = Color.WHITE
	mutated_button.modulate = Color.WHITE
	
	print("SELECTED ITEM: SHOVEL")

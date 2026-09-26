extends Control

@export var player: CharacterBody2D

@onready var base_button: TextureButton = $Panel/HBoxContainer/TextureButton
@onready var mutated_button: TextureButton = $Panel/HBoxContainer/TextureButton2
@onready var shovel_button: TextureButton = $Panel/HBoxContainer/TextureButton3
@onready var gun_button: TextureButton = $Panel/HBoxContainer/TextureButton4
@onready var nuke_button: TextureButton = $Panel/HBoxContainer/TextureButton5

@onready var base_quantity_label: Label = (
	$Panel/HBoxContainer/TextureButton/quantity_label
)
@onready var mutated_quantity_label: Label = (
	$Panel/HBoxContainer/TextureButton2/quantity_label2
)

const GUN_ID: String = "gun"
const NUKE_ID: String = "nuke"
const SHOVEL_ID: String = "shovel"
const BASE_TOMATO_ID: String = "base_tomato"
const MUTATED_TOMATO_ID: String = "mutated_tomato"


var hotbar = [
	GUN_ID,
	NUKE_ID,
	SHOVEL_ID,
	BASE_TOMATO_ID,
	MUTATED_TOMATO_ID,
]


var items = {
	GUN_ID: {
		"name": "Gun",
		"category": "Weapon",
		"stackable": false,
		"quantity": 1,
	},
	NUKE_ID: {
		"name": "Nuke",
		"category": "Weapon",
		"stackable": false,
		"quantity": 1,
	},
	SHOVEL_ID: {
		"name": "Shovel",
		"category": "Tool",
		"stackable": false,
		"quantity": 1,
	},
	BASE_TOMATO_ID: {
		"name": "Tomato Seed",
		"category": "Seed",
		"stackable": true,
		"quantity": 5,
	},
	MUTATED_TOMATO_ID: {
		"name": "Mutated Tomato Seed",
		"category": "Seed",
		"stackable": true,
		"quantity": 5,
	},
}


func _ready() -> void:
	print("INVENTORY LOADED")
	base_button.pressed.connect(_on_base_tomato_pressed)
	mutated_button.pressed.connect(_on_mutated_tomato_pressed)
	shovel_button.pressed.connect(_on_shovel_pressed)
	gun_button.pressed.connect(_on_gun_pressed)
	nuke_button.pressed.connect(_on_nuke_pressed)
	
	player = get_tree().current_scene.get_node("Player")
	
	player.seed_planted.connect(_on_seed_planted)
	player.tomato_harvested.connect(_on_tomato_harvested)
	
	update_quantity_labels()


func _on_base_tomato_pressed() -> void:
	print("BASE TOMATO BUTTON PRESSED")
	
	player.select_base_tomato()
	
	# Highlight base tomato button
	base_button.modulate = Color(1.5, 1.5, 1.5)
	
	# Undo highlight on mutated tomato button
	mutated_button.modulate = Color.WHITE
	
	print("PLAYER REFERENCE:", player)
	print("SELECTED SEED:", player.selected_seed)

	base_button.button_pressed = true
	mutated_button.button_pressed = false


func _on_mutated_tomato_pressed() -> void:
	print("MUTATED TOMATO BUTTON PRESSED")
	
	player.select_mutated_tomato()
	
	# Highlight mutated tomato button
	mutated_button.modulate = Color(1.5, 1.5, 1.5)
	
	# Undo highlight on base tomato button
	base_button.modulate = Color.WHITE
	
	print("PLAYER REFERENCE:", player)
	print("SELECTED SEED:", player.selected_seed)

	base_button.button_pressed = false
	mutated_button.button_pressed = true


func _on_seed_planted(seed_id: String) -> void:
	if not items.has(seed_id):
		print("Invalid seed ID:", seed_id)
		return

	if not items[seed_id]["stackable"]:
		print("Item cannot be used as a seed:", seed_id)
		return

	if items[seed_id]["quantity"] <= 0:
		print("Cannot plant seed: no seeds remaining.")
		return
		
	items[seed_id]["quantity"] -= 1
	update_quantity_labels()


func update_quantity_labels() -> void:
	base_quantity_label.text = str(items[BASE_TOMATO_ID]["quantity"])
	mutated_quantity_label.text = str(items[MUTATED_TOMATO_ID]["quantity"])


func _on_tomato_harvested(tomato_id: String, amount: int) -> void:
	if not items.has(tomato_id):
		print("Invalid tomato ID:", tomato_id)
		return

	if not items[tomato_id]["stackable"]:
		print("Tomato item cannot be stacked:", tomato_id)
		return
		
	items[tomato_id]["quantity"] += amount
	update_quantity_labels()
	
	print("Added ", amount, " ", tomato_id, " seeds")
	print("Harvested:", tomato_id)
	print("New quantity:", items[tomato_id]["quantity"])


func _on_shovel_pressed() -> void:
	print("SHOVEL BUTTON PRESSED")

	player.select_shovel()

	# Highlight shovel
	shovel_button.modulate = Color(1.5, 1.5, 1.5)

	# Remove other highlights
	gun_button.modulate = Color.WHITE
	base_button.modulate = Color.WHITE
	mutated_button.modulate = Color.WHITE

	print("SELECTED ITEM: SHOVEL")


func _on_gun_pressed() -> void:
	print("GUN BUTTON PRESSED")

	player.select_gun()

	# Highlight gun
	gun_button.modulate = Color(1.5, 1.5, 1.5)

	# Remove other highlights
	shovel_button.modulate = Color.WHITE
	base_button.modulate = Color.WHITE
	mutated_button.modulate = Color.WHITE

	print("SELECTED ITEM: GUN")


func _on_nuke_pressed() -> void:
	print("NUKE BUTTON PRESSED")

	player.select_nuke()

	nuke_button.modulate = Color(1.5, 1.5, 1.5)

	gun_button.modulate = Color.WHITE
	shovel_button.modulate = Color.WHITE
	base_button.modulate = Color.WHITE
	mutated_button.modulate = Color.WHITE

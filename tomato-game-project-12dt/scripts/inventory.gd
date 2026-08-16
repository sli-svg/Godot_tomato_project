extends Control

@export var player: CharacterBody2D

@onready var base_button: TextureButton = $Panel/HBoxContainer/TextureButton
@onready var mutated_button: TextureButton = $Panel/HBoxContainer/TextureButton2


func _on_base_tomato_pressed() -> void:
	print("BASE TOMATO BUTTON PRESSED")
	player.select_base_tomato()
	print("PLAYER REFERENCE:", player)
	print("SELECTED SEED:", player.selected_seed)

	base_button.button_pressed = true
	mutated_button.button_pressed = false


func _on_mutated_tomato_pressed() -> void:
	print("MUTATED TOMATO BUTTON PRESSED")
	player.select_mutated_tomato()
	print("PLAYER REFERENCE:", player)
	print("SELECTED SEED:", player.selected_seed)

	base_button.button_pressed = false
	mutated_button.button_pressed = true


#other half of code for 
func _ready() -> void:
	print("INVENTORY LOADED")
	base_button.pressed.connect(_on_base_tomato_pressed)
	mutated_button.pressed.connect(_on_mutated_tomato_pressed)

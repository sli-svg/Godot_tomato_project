extends CharacterBody2D

signal seed_planted(_seed_id: String)

@export var bullet_spawn: Marker2D
@export var bullet_scene: PackedScene
@export var health_ui: ProgressBar
@export var bullet_timer: Timer

@export var base_tomato: PackedScene
@export var mutated_tomato: PackedScene

var speed: float = 300.0
var health: int = 100
var _can_shoot: bool = true
var selected_seed: PackedScene = null
var selected_seed_id : String = ""


func _ready() -> void:
	if health_ui != null:
		health_ui.max_value = health
		health_ui.value = health
	
		print("PLAYER:", self)


func _physics_process(_delta: float) -> void:
	var direction: Vector2 = Vector2.ZERO
	
	#Get movement input
	direction.x = Input.get_axis("ui_left", "ui_right")
	direction.y = Input.get_axis("ui_up", "ui_down")
	
	#Action input - shoot
	if Input.is_action_pressed("ui_shoot") and _can_shoot:
		_shoot()
	
	#Action input - plant seed. 
	if Input.is_action_just_pressed("plant_seed"):
		plant_seed(global_position)
	
	#Apply movement
	velocity = speed * direction.normalized()
	move_and_slide()
	
	


func _shoot() -> void:
	var bullet = bullet_scene.instantiate()
	
	bullet.global_position = bullet_spawn.global_position 
	bullet.rotation = (get_global_mouse_position()-bullet.global_position).angle()
	
	add_sibling(bullet)
	
	_can_shoot = false
	bullet_timer.start()


	
func _take_damage() -> void:
	if health > 1:
		health -= 1
		health_ui.value = health
		print("Player took damage")
	else:
		get_tree().call_deferred("reload_current_scene")
		#change this later


func _bullet_cooldown() -> void:
	_can_shoot = true


func select_base_tomato() -> void:
	print("Base tomato variable:", base_tomato)
	selected_seed = base_tomato
	selected_seed_id = "base_tomato"
	print("Base tomato selected on:", self)


func select_mutated_tomato() -> void:
	print("Mutated tomato variable:", mutated_tomato)
	selected_seed = mutated_tomato
	selected_seed_id = "mutated_tomato"
	print("Mutated tomato selected on:", self)


func plant_seed(plant_position: Vector2) -> void:
	if selected_seed == null:
		print("No seed selected!")
		return
	
	var inventory = get_tree().current_scene.get_node("CanvasLayer/Control/inventory")
	
	if inventory.items[selected_seed_id]["quantity"] <= 0:
		print("No seeds left!")
		return 
	
	print("selected seed:", selected_seed)
	
	var tomato = selected_seed.instantiate()
	tomato.global_position = plant_position
	get_tree().current_scene.add_child(tomato)
	
	seed_planted.emit(selected_seed_id)


func _on_seed_planted(seed_id: String) -> void:
	pass # Replace with function body.

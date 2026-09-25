extends CharacterBody2D

signal seed_planted(_seed_id: String)
signal tomato_harvested(_tomato_id: String)

@export var bullet_spawn: Marker2D
@export var bullet_scene: PackedScene
@export var health_ui: ProgressBar
@export var bullet_timer: Timer

@export var base_tomato: PackedScene
@export var mutated_tomato: PackedScene

@export var harvest_range: float = 100.0
@export var harvest_time: float = 3.0

@onready var harvest_radius: Line2D = $harvest_radius

var harvesting: bool = false
var harvest_target: Node2D = null
var harvest_progress: float = 0.0

var speed: float = 300.0
var health: int = 100
var _can_shoot: bool = true

var selected_seed: PackedScene = null
var selected_seed_id : String = ""

var selected_item: String = ""

func _ready() -> void:
	if health_ui != null:
		health_ui.max_value = health
		health_ui.value = health
		
		print("PLAYER:", self)
	
	# Harvest radius
	print(harvest_radius)
	harvest_radius.radius = harvest_range
	harvest_radius.create_circle()
	harvest_radius.visible = false


func _physics_process(delta: float) -> void:
	var direction: Vector2 = Vector2.ZERO
	
	# Get movement input
	direction.x = Input.get_axis("ui_left", "ui_right")
	direction.y = Input.get_axis("ui_up", "ui_down")
	
	# Handle player actions
	if Input.is_action_pressed("ui_shoot") and _can_shoot:
		_shoot()
	
	if Input.is_action_just_pressed("plant_seed"):
		plant_seed(global_position)
	
	# Harvest
	if selected_item == "shovel":
		handle_harvesting(delta)
	else:
		reset_harvest()
	
	# Apply movement
	velocity = speed * direction.normalized()
	move_and_slide()


func _process(_delta: float) -> void:
	update_harvest_target()


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
		# change this later


func _bullet_cooldown() -> void:
	_can_shoot = true


func select_base_tomato() -> void:
	print("Base tomato variable:", base_tomato)
	selected_item = "base_tomato"
	selected_seed = base_tomato
	selected_seed_id = "base_tomato"
	print("Base tomato selected on:", self)


func select_mutated_tomato() -> void:
	print("Mutated tomato variable:", mutated_tomato)
	selected_item = "mutated_tomato"
	selected_seed = mutated_tomato
	selected_seed_id = "mutated_tomato"
	print("Mutated tomato selected on:", self)


func select_shovel() -> void:
	selected_item = "shovel"

	# Deselect seed
	selected_seed = null
	selected_seed_id = ""

	print("Shovel selected")


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


func find_closest_tomato() -> Node2D:
	var closest_tomato: Node2D = null
	var closest_distance := harvest_range

	for tomato in get_tree().get_nodes_in_group("Tomato"):
		if not is_instance_valid(tomato):
			continue
			
		if not tomato.harvest_ready:
			continue

		var distance := global_position.distance_to(tomato.global_position)

		if distance < closest_distance:
			closest_distance = distance
			closest_tomato = tomato

	return closest_tomato


func update_harvest_target() -> void:
	if harvesting:
		return
	
	harvest_target = find_closest_tomato()
	
	if harvest_target != null:
		harvest_radius.visible = true
	else:
		harvest_radius.visible = false


func handle_harvesting(delta: float) -> void:
	if harvest_target == null:
		return
	
	if not is_instance_valid(harvest_target):
		reset_harvest()
		return

	# Check distance from player to tomato
	var distance := global_position.distance_to(harvest_target.global_position)

	if distance > harvest_range:
		reset_harvest()
		return

	# Player is holding E
	if Input.is_action_pressed("harvest"):
		if not harvesting:
			harvesting = true
			harvest_target.being_harvested = true
		
		harvest_progress += delta

		# Three seconds completed
		if harvest_progress >= harvest_time:
			harvest_tomato()
			
	else:
		# Player release E
		reset_harvest()


func harvest_tomato() -> void:
	if harvest_target == null:
		return

	var tomato = harvest_target

	if not is_instance_valid(tomato):
		reset_harvest()
		return
		
	# Final distance check
	var distance := global_position.distance_to(tomato.global_position)
	
	if distance > harvest_range:
		reset_harvest()
		return

	var tomato_type: String = tomato.tomato_type

	if tomato_type == "normal":
		tomato_harvested.emit("base_tomato")

	elif tomato_type == "mutated":
		tomato_harvested.emit("mutated_tomato")

	else:
		print("Unknown tomato type:", tomato_type)
		reset_harvest()
		return

	print("HARVESTED:", tomato_type)

	tomato.queue_free()

	reset_harvest()
	
	
func reset_harvest() -> void:
	if harvest_target != null and is_instance_valid(harvest_target):
		harvest_target.being_harvested = false

	harvest_target = null
	harvest_progress = 0.0
	harvesting = false
	
	print("HARVEST RESET! harvesting =", harvesting)
	

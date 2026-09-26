extends CharacterBody2D

signal seed_planted(_seed_id: String)
signal tomato_harvested(_tomato_id: String, _amount: int)

@export var bullet_spawn: Marker2D
@export var bullet_scene: PackedScene
@export var health_ui: ProgressBar
@export var bullet_timer: Timer

@export var base_tomato: PackedScene
@export var mutated_tomato: PackedScene
@export var nuke_scene: PackedScene

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

var nuke_placed: bool = false
var nuke: Node2D = null

const INVENTORY_PATH: String = "CanvasLayer/Control/inventory"
const BASE_TOMATO_ID: String = "base_tomato"
const MUTATED_TOMATO_ID: String = "mutated_tomato"
const ITEM_SHOVEL: String = "shovel"
const ITEM_GUN: String = "gun"
const ITEM_NUKE: String = "nuke"


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
	if Input.is_action_just_pressed("plant_seed"):
		plant_seed(global_position)
	
	# Harvest
	if selected_item == ITEM_SHOVEL:
		update_harvest_target()
		handle_harvesting(delta)
	else:
		reset_harvest()
	
	# Shoot
	if selected_item == ITEM_GUN:
		_shoot()
	
	# Nuke
	if selected_item == ITEM_NUKE:
		nuke_preview()
	
	# Apply movement
	velocity = speed * direction.normalized()
	move_and_slide()


func _shoot() -> void:
	if not Input.is_action_just_pressed("ui_shoot"):
		return

	if not _can_shoot:
		return
		
	if bullet_scene == null:
		print("Cannot shoot: bullet scene is not assigned.")
		return

	if bullet_spawn == null:
		print("Cannot shoot: bullet spawn point is not assigned.")
		return

	if bullet_timer == null:
		print("Cannot shoot: bullet timer is not assigned.")
		return

	var bullet = bullet_scene.instantiate()

	bullet.global_position = bullet_spawn.global_position
	bullet.rotation = bullet.global_position.angle_to_point(get_global_mouse_position())


	get_tree().current_scene.add_child(bullet)

	_can_shoot = false
	bullet_timer.start()


func _take_damage() -> void:
	if health > 1:
		health -= 1
		if health_ui != null:
			health_ui.value = health

	else:
		die()


func die() -> void:
	print("PLAYER DIED")
	get_tree().call_deferred("reload_current_scene")


func _bullet_cooldown() -> void:
	_can_shoot = true


func select_base_tomato() -> void:
	cancel_nuke()
	print("Base tomato variable:", base_tomato)
	selected_item = BASE_TOMATO_ID
	selected_seed = base_tomato
	selected_seed_id = BASE_TOMATO_ID
	print("Base tomato selected on:", self)


func select_mutated_tomato() -> void:
	cancel_nuke()
	print("Mutated tomato variable:", mutated_tomato)
	selected_item = MUTATED_TOMATO_ID
	selected_seed = mutated_tomato
	selected_seed_id = MUTATED_TOMATO_ID
	print("Mutated tomato selected on:", self)


func select_shovel() -> void:
	cancel_nuke()
	selected_item = ITEM_SHOVEL

	# Deselect seed
	selected_seed = null
	selected_seed_id = ""

	print("Shovel selected")


func select_gun() -> void:
	cancel_nuke()
	selected_item = ITEM_GUN

	# Deselect seed
	selected_seed = null
	selected_seed_id = ""

	print("Gun selected")


func select_nuke() -> void:
	selected_item = ITEM_NUKE

	# Deselect seed
	selected_seed = null
	selected_seed_id = ""

	print("Nuke selected")


func plant_seed(plant_position: Vector2) -> void:
	if selected_seed == null:
		print("No seed selected!")
		return
	
	var inventory = get_tree().current_scene.get_node(INVENTORY_PATH)
	
	if not inventory.items.has(selected_seed_id):
		print("Invalid seed ID:", selected_seed_id)
		return
	
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
		tomato_harvested.emit(BASE_TOMATO_ID, tomato.amount)

	elif tomato_type == "mutated":
		tomato_harvested.emit(MUTATED_TOMATO_ID, tomato.amount)

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


func nuke_preview() -> void:
	if nuke == null:
		if nuke_scene == null:
			print("Cannot use nuke: nuke scene is not assigned.")
			selected_item = ""
			return
		
		nuke = nuke_scene.instantiate()
		get_tree().current_scene.add_child(nuke)

	if not nuke_placed:
		nuke.global_position = get_global_mouse_position()

		if Input.is_action_just_pressed("place_nuke"):
			nuke_placed = true
			nuke.placed = true
			print("NUKE PLACED")
	
	if nuke_placed:
		if Input.is_action_just_pressed("detonate_nuke"):
			nuke.detonate()
			nuke = null
			nuke_placed = false
			selected_item = ""


func cancel_nuke() -> void:
	if nuke != null and not nuke_placed:
		nuke.queue_free()
		nuke = null

extends CharacterBody2D


@export var bullet_spawn: Marker2D
@export var bullet_scene: PackedScene
@export var health_ui: ProgressBar
@export var bullet_timer: Timer

@export var base_tomato: PackedScene
@export var mutated_tomato: PackedScene

var speed: float = 300.0
var health: int = 100
var _can_shoot: bool = true
var selected_seed: PackedScene


func _ready() -> void:
	if health_ui != null:
		health_ui.max_value = health
		health_ui.value = health


func _physics_process(_delta: float) -> void:
	var direction: Vector2 = Vector2(0.0, 0.0)
	direction.x = Input.get_axis("ui_left", "ui_right")
	direction.y = Input.get_axis("ui_up", "ui_down")
	
	if Input.is_action_just_pressed("plant_seed"):
		plant_seed()
	
	velocity = speed * direction.normalized()
	
	if Input.is_action_pressed("ui_shoot") and _can_shoot:
		_shoot()
	
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


func _plant_seed() -> void:
	pass
	#check that the number of selected seed isnt 0.
	
func _input(event):
	if event.is_action_pressed("plant"):
		plant_base_tomato()

func plant_base_tomato():
	var tomato = base_tomato.instantiate()
	# Plant at the player's feet
	tomato.global_position = global_position
	# Add it to the world, not as a child of the player
	get_parent().add_child(tomato)


func select_base_tomato() -> void:
	selected_seed = base_tomato


func select_mutated_tomato() -> void:
	selected_seed = mutated_tomato


func plant_seed() -> void:
	if selected_seed == null:
		print("No seed selected!")
		return
	
	var tomato = selected_seed.instantiate()
	# Plant at the player's feet
	tomato.global_position = global_position
	# Add it to the world, not as a child of the player
	get_parent().add_child(tomato)
	

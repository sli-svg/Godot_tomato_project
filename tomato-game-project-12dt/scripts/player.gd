extends CharacterBody2D


signal plant_seed 


@export var bullet_spawn: Marker2D
@export var bullet_scene: PackedScene
@export var health_ui: ProgressBar
@export var bullet_timer: Timer


var speed: float = 300.0
var health: int = 100.0
var _can_shoot: bool = true


func _ready() -> void:
	if not health_ui == null:
		health_ui.max_value = health
		health_ui.value = health


func _process(_delta: float) -> void:
	var direction: Vector2 = Vector2(0.0, 0.0)
	direction.x = Input.get_axis("ui_left", "ui_right")
	direction.y = Input.get_axis("ui_up", "ui_down")
	
	if Input.is_action_just_pressed("plant_seed"):
		emit_signal("plant_seed")
	
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

	
func take_damage() -> void:
	if health > 1:
		health -= 1
		health_ui.value = health
	else:
		get_tree().call_deferred("reload_current_scene")


func _bullet_cooldown() -> void:
	_can_shoot = true

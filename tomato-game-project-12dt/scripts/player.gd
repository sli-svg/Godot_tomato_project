extends CharacterBody2D

signal plant_seed 


@export var health_ui: ProgressBar


var speed: float = 300.0
var health: int = 10.0


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
	move_and_slide()
	
	
func take_damage() -> void:
	if health > 1:
		health -= 1
		health_ui.value = health
	else:
		get_tree().call_deferred("reload_current_scene")

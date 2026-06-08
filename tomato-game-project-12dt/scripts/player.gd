extends CharacterBody2D

signal plant_seed 

var speed: float = 300.0


func _ready():
	pass


func _process(delta: float) -> void:
	var direction: Vector2 = Vector2(0.0, 0.0)
	direction.x = Input.get_axis("ui_left", "ui_right")
	direction.y = Input.get_axis("ui_up", "ui_down")
	
	if Input.is_action_just_pressed("plant_seed"):
		emit_signal("plant_seed")
		
	
	velocity = speed * direction.normalized()
	move_and_slide()

extends CharacterBody2D


@export var amount: int = 2
@export var harvest_ready: bool = false
<<<<<<< Updated upstream
@export var health: int = 10
@export var dangerous_stage: int = 2

@onready var player = get_tree().get_first_node_in_group("player")
=======
@export var age: int = 0
>>>>>>> Stashed changes


var growth_stage: int = 0 
var chase_player: bool = false
var speed: int = 50


func _ready() -> void:
	$AnimationPlayer.play(str(growth_stage))

func _physics_process(delta) -> void:
	if growth_stage >= 2:
		chase_player = true
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
	else:
		pass
		#can add more later. 
	


func _on_timer_timeout() -> void:
	growth_stage += 1
	$AnimationPlayer.play(str(growth_stage))


func _damage_player(body: Node2D) -> void:
	print("player touched plant")
	if body.is_in_group("player") and growth_stage >= dangerous_stage:
		body._take_damage()
		print("Player took damage")


func _take_damage() -> void:
	if health > 1:
		print("Tomato is abt to -1 health")
		health -= 1
		print("Tomato -1 health alr")
		print("tomato health is:" , int(health))
	else:
		queue_free()

extends CharacterBody2D


@export var amount: int = 2
@export var harvest_ready: bool = false
@export var health: int = 10
@export var dangerous_stage: int = 2

@onready var player = get_tree().get_first_node_in_group("player")

@export var age: int = 0


var growth_stage: int = 0 
var chase_player: bool = false
var speed: int = 50


func _ready() -> void:
	#Starts plant's current growth animation when it first appears in the game, 
	#so player can see the current growth stage of tomato immediately. 
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
#chase the player after it ripens to act as an enemy


func _on_timer_timeout() -> void:
	#Increases growth stage each time the timer finishes
	growth_stage += 1
	#Play animation which matches plant's new growth stage
	$AnimationPlayer.play(str(growth_stage))
#


func _deal_damage(body: Node2D) -> void:
	print("player touched plant")
	if body.is_in_group("player") and growth_stage >= dangerous_stage:
		body._take_damage()
		print("Player took damage")


func _take_damage() -> void:
	if health > 1:
		health -= 1
		print("Tomato took damage")
	else:
		queue_free()

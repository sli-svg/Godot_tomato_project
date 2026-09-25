extends CharacterBody2D

@export_enum("normal", "mutated") var tomato_type: String = "normal"

@export var amount: int = 2
@export var harvest_ready: bool = false
@export var health: int = 5
@export var dangerous_stage: int = 2

@onready var player = get_tree().get_first_node_in_group("player")

@export var age: int = 0

# Strength of knockback 
const KNOCKBACK_STRENGTH: float = 300.0
const KNOCKBACK_TIME: float = 0.2
var knockback_timer: float = 0.0
 
var growth_stage: int = 0
var chase_player: bool = false
var speed: int = 50

var being_harvested: bool = false


func _ready() -> void:
	# Starts plant's growth animation
	$AnimationPlayer.play(str(growth_stage))
	add_to_group("Tomato")

func _physics_process(_delta) -> void:
	# Continuous knockback
	if knockback_timer > 0:
		knockback_timer -= _delta
		move_and_slide()
		return
		
	# Stationary while being harvested
	if being_harvested:
		velocity = Vector2.ZERO
		return
	
	if growth_stage >= 1:
		harvest_ready = true

	if growth_stage >= 2:
		chase_player = true
		
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()


func _on_timer_timeout() -> void:
	# Increases growth stage each time the timer finishes
	growth_stage += 1
	
	# Prevent further growth after stage 2
	if growth_stage > 2:
		growth_stage = 2
	
	# Play animation which matches plant's new growth stage
	$AnimationPlayer.play(str(growth_stage))


func _deal_damage(body: Node2D) -> void:
	print("player touched plant")
	
	if body.is_in_group("player") and growth_stage >= dangerous_stage:
		body._take_damage()
		print("Player took damage")
		
		var knockback_direction = (global_position - body.global_position).normalized()
		velocity = knockback_direction * KNOCKBACK_STRENGTH
		knockback_timer = KNOCKBACK_TIME


func _take_damage() -> void:
	if health > 1:
		health -= 1
		print("Tomato took damage")
	else:
		queue_free()

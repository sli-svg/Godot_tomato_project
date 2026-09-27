extends CharacterBody2D

@export_enum("normal", "mutated") var tomato_type: String = "normal"

@export var amount: int = 2
@export var harvest_ready: bool = false
@export var health: int = 5
@export var dangerous_stage: int = 2

@onready var player = get_tree().get_first_node_in_group("player")
@onready var health_label: Label = $health_label

const HARVEST_STAGE: int = 1
const MAX_GROWTH_STAGE: int = 2

const KNOCKBACK_STRENGTH: float = 300.0
const KNOCKBACK_TIME: float = 0.2
var knockback_timer: float = 0.0
 
var growth_stage: int = 0
var speed: int = 50

var being_harvested: bool = false
var is_screaming: bool = false


func _ready() -> void:
	# Start the growth animation at the current growth stage.
	$AnimationPlayer.play(str(growth_stage))
	add_to_group("Tomato")
	update_health_label()


func _physics_process(_delta) -> void:
	# Continue applying knockback until the timer expires.
	if knockback_timer > 0:
		knockback_timer -= _delta
		move_and_slide()
		return
		
	# Prevent the tomato from moving while it is being harvested.
	if being_harvested:
		velocity = Vector2.ZERO
		return
	
	# Allow the player to harvest the tomato once it reaches the harvest stage.
	if growth_stage >= HARVEST_STAGE:
		harvest_ready = true
	
	# Make the tomato chase the player and scream once it mutates.
	if growth_stage >= MAX_GROWTH_STAGE:
		if not is_screaming:
			is_screaming = true
			$AudioStreamPlayer2D.play()
		
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()


func _on_timer_timeout() -> void:
	# Increase the growth stage whenever the timer finishes.
	growth_stage += 1
	
	# Prevent the growth stage from exceeding the maximum.
	if growth_stage > MAX_GROWTH_STAGE:
		growth_stage = MAX_GROWTH_STAGE
	
	# Play the animation that matches the new growth stage.
	$AnimationPlayer.play(str(growth_stage))


func _deal_damage(body: Node2D) -> void:
	print("player touched plant")
	
	if body.is_in_group("player") and growth_stage >= dangerous_stage:
		body._take_damage()
		print("Player took damage")
		
		# Knock the tomato away from the player.
		var knockback_direction = (global_position - body.global_position).normalized()
		velocity = knockback_direction * KNOCKBACK_STRENGTH
		knockback_timer = KNOCKBACK_TIME


func _take_damage() -> void:
	if health > 1:
		health -= 1
		update_health_label()
		print("Tomato took damage")
	else:
		$AudioStreamPlayer2D.stop()
		queue_free()


func _on_audio_stream_player_2d_finished() -> void:
	if is_screaming:
		$AudioStreamPlayer2D.play()


func update_health_label() -> void:
	health_label.text = str(health) + " / 5"

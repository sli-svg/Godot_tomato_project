extends Node2D


@export var amount: int = 2
@export var harvest_ready: bool = false
@export var health: int = 10
@export var dangerous_stage: int = 2


var growth_stage: int = 0 


func _ready() -> void:
	$AnimationPlayer.play(str(growth_stage))


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

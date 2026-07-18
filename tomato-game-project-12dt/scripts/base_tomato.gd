extends Node2D


@export var amount: int = 2
@export var harvest_ready: bool = false
@export var health: int = 10


var index = 0 


func _ready() -> void:
	$AnimationPlayer.play(str(index))


func _on_timer_timeout() -> void:
	index += 1
	$AnimationPlayer.play(str(index))


func _damage_player(body: Node2D) -> void:
	print("player touched plant")
	if body.is_in_group("player"):
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

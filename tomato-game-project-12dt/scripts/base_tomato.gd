extends CharacterBody2D


@export var amount: int = 2
@export var harvest_ready: bool = false

var index = 0 


func _ready() -> void:
	$AnimationPlayer.play(str(index))


func _on_timer_timeout() -> void:
	index += 1
	$AnimationPlayer.play(str(index))

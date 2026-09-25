extends Area2D

const SPEED: float = 1300.0


func _process(delta: float) -> void:
	move_local_x(SPEED * delta)


func _deal_damage(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body._take_damage()
		queue_free()

extends Area2D

var speed: float = 1300.0


func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move_local_x(speed * delta)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.take_damage()
		queue_free()

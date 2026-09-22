extends Line2D

@export var radius: float = 100.0
@export var segments: int = 64
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	default_color = Color(1.0, 0.75, 0.1, 0.5)
	width = 3.0
	create_circle()
	pass # Replace with function body.

func create_circle() -> void:
	clear_points()
	for i in range(segments + 1):
		var angle := TAU * float(i) / float(segments)
		var point := Vector2(
			cos(angle),
			sin(angle)
		) * radius
		
		add_point(point)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

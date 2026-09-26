extends Line2D

@export var radius: float = 100.0
@export var segments: int = 64

const CIRCLE_LINE_WIDTH: float = 3.0


func _ready() -> void:
	default_color = Color(1.0, 0.75, 0.1, 0.5)
	width = CIRCLE_LINE_WIDTH
	create_circle()


func create_circle() -> void:
	if segments < 3:
		segments = 3

	clear_points()

	for i in range(segments + 1):
		var angle := TAU * float(i) / float(segments)
		var point := Vector2(
			cos(angle),
			sin(angle)
		) * radius

		add_point(point)

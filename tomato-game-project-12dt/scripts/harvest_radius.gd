extends Line2D

const DEFAULT_RADIUS: float = 100.0
const CIRCLE_LINE_WIDTH: float = 3.0

@export var radius: float = DEFAULT_RADIUS
@export var segments: int = 64


func _ready() -> void:
	if radius <= 0:
		radius = DEFAULT_RADIUS
	
	default_color = Color(1.0, 0.75, 0.1, 0.5)
	width = CIRCLE_LINE_WIDTH
	create_circle()


func create_circle() -> void:
	# Ensure there are enough segments to create a closed shape.
	if segments < 3:
		segments = 3
	
	clear_points()
	
	# Calculate points around the circumference of the circle.
	for i in range(segments + 1):
		var angle := TAU * float(i) / float(segments)
		var point := Vector2(
			cos(angle),
			sin(angle)
		) * radius
	
		add_point(point)

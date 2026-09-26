extends Area2D

const DEFAULT_EXPLOSION_RADIUS: float = 200.0

@export var explosion_radius: float = DEFAULT_EXPLOSION_RADIUS

var placed: bool = false

const CIRCLE_SEGMENTS: int = 64


func _ready() -> void:
	if explosion_radius <= 0:
		print("Invalid explosion radius. Using default value.")
		explosion_radius = DEFAULT_EXPLOSION_RADIUS
	
	# Create the visual explosion radius.
	$explosion_radius.polygon = create_circle()


func _process(_delta: float) -> void:
	# Follow the mouse cursor until the nuke is placed.
	if not placed:
		global_position = get_global_mouse_position()


func create_circle() -> PackedVector2Array:
	var points := PackedVector2Array()
	
	# Generate points around the circumference of the explosion radius.
	for i in range(CIRCLE_SEGMENTS):
		var angle = TAU * i / CIRCLE_SEGMENTS
		var point = Vector2(cos(angle), sin(angle)) * explosion_radius
		points.append(point)
	
	return points


func detonate() -> void:
	print("NUKE DETONATED")
	
	var tomatoes = get_tree().get_nodes_in_group("Tomato")
	
	# Check each tomato to see if it is within the explosion radius.
	for tomato in tomatoes:
		if not is_instance_valid(tomato):
			continue
	
		var distance = global_position.distance_to(tomato.global_position)
		
		if distance <= explosion_radius:
			print("NUKE KILLED TOMATO")
			tomato.queue_free()
	
	var player = get_tree().get_first_node_in_group("player")
	
	# Check whether the player is within the explosion radius.
	if player != null:
		var distance = global_position.distance_to(player.global_position)
		
		if distance <= explosion_radius:
			print("NUKE KILLED PLAYER")
			player.die()
	
	queue_free()

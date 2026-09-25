extends Area2D

@export var explosion_radius: float = 200.0

var placed: bool = false


func _ready() -> void:
	$explosion_radius.polygon = create_circle()


func _process(_delta: float) -> void:
	if not placed:
		global_position = get_global_mouse_position()


func create_circle() -> PackedVector2Array:
	var points := PackedVector2Array()

	for i in range(64):
		var angle = TAU * i / 64
		var point = Vector2(cos(angle), sin(angle)) * explosion_radius
		points.append(point)

	return points


func detonate() -> void:
	print("NUKE DETONATED")

	var tomatoes = get_tree().get_nodes_in_group("Tomato")

	for tomato in tomatoes:
		if not is_instance_valid(tomato):
			continue

		var distance = global_position.distance_to(tomato.global_position)

		if distance <= explosion_radius:
			print("NUKE KILLED TOMATO")
			tomato.queue_free()

	var player = get_tree().get_first_node_in_group("player")

	if player != null:
		var distance = global_position.distance_to(player.global_position)

		if distance <= explosion_radius:
			print("NUKE KILLED PLAYER")
			player.die()

	queue_free()

extends CharacterBody2D


var speed: float = 250.0
var player: CharacterBody2D
var health: int = 2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for node in get_tree().get_nodes_in_group("player"):
		player = node


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not player == null: 
		look_at(player.global_position)
		velocity = Vector2(1,0).rotated(rotation) * speed
		
		move_and_slide()


func take_damage() -> void:
	if health > 1:
		health -= 1
	else:
		queue_free()


func _damage_player(body: Node2D) -> void:
	if body == player:
		player.take_damage()

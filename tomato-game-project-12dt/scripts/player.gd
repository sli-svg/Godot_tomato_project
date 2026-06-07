extends CharacterBody2D

var movespeed = 500


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _ready():
	pass


func _physics_process(delta):
	var motion = Vector2()
	
	if Input.is_action_just_pressed('up'):
		motion.y -= 1
	if Input.is_action_just_pressed('down'):
		motion.y += 1
	if Input.is_action_just_pressed('up'):
		motion.x -= 1
	if Input.is_action_just_pressed('up'):
		motion.x += 1
	
	motion = motion.normalized()
	
	motion = move_and_slide(motion * movespeed)



	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

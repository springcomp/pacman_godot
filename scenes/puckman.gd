extends SpeedyCharacterBody2D

class_name PuckMan


@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionHelper2D = $CollisionShape2D

var movement_direction = Vector2.ZERO
var next_movement_direction = Vector2.ZERO


func _physics_process(delta: float):
	process_input()
	
	if movement_direction == Vector2.ZERO:
		movement_direction = next_movement_direction

	if collision_shape_2d.can_move_in_direction(next_movement_direction, delta):
		movement_direction = next_movement_direction

	velocity = speed * movement_direction

	animate()	
	adjust_rotation()	
	move_and_slide()

func process_input():
	if Input.is_action_pressed("move_right"):
		next_movement_direction = Vector2.RIGHT
	elif Input.is_action_pressed("move_down"):
		next_movement_direction = Vector2.DOWN
	elif Input.is_action_pressed("move_left"):
		next_movement_direction = Vector2.LEFT
	elif Input.is_action_pressed("move_up"):
		next_movement_direction = Vector2.UP
	else:
		next_movement_direction = Vector2.ZERO

func adjust_rotation():
	if movement_direction == Vector2.RIGHT:
		rotation_degrees = 0
	elif movement_direction == Vector2.DOWN:
		rotation_degrees = 90
	elif movement_direction == Vector2.LEFT:
		rotation_degrees = 180
	elif movement_direction == Vector2.UP:
		rotation_degrees = 270
	else:
		next_movement_direction = Vector2.ZERO

func animate():
	if movement_direction == Vector2.ZERO:
		sprite.stop()
	else:
		sprite.play()

extends CharacterBody2D

class_name PuckMan

@export var speed: int = 300

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var movement_direction = Vector2.ZERO
var next_movement_direction = Vector2.ZERO
var shape_query: PhysicsShapeQueryParameters2D

func _ready():
	shape_query = PhysicsShapeQueryParameters2D.new()
	shape_query.shape = collision_shape_2d.shape
	shape_query.collide_with_areas = false
	shape_query.collide_with_bodies = true
	shape_query.collision_mask = 2

func _physics_process(delta: float):
	process_input()
	
	if movement_direction == Vector2.ZERO:
		movement_direction = next_movement_direction

	if can_move_in_direction(next_movement_direction, delta):
		movement_direction = next_movement_direction

	velocity = speed * movement_direction
	
	animate()	
	move_and_slide()

func process_input():
	if Input.is_action_pressed("move_right"):
		next_movement_direction = Vector2.RIGHT
		rotation_degrees = 0
	elif Input.is_action_pressed("move_down"):
		next_movement_direction = Vector2.DOWN
		rotation_degrees = 90
	elif Input.is_action_pressed("move_left"):
		next_movement_direction = Vector2.LEFT
		rotation_degrees = 0
	elif Input.is_action_pressed("move_up"):
		next_movement_direction = Vector2.UP
		rotation_degrees = 270
	else:
		next_movement_direction = Vector2.ZERO

func can_move_in_direction(dir: Vector2, delta: float) -> bool:
	shape_query.transform = global_transform.translated(dir * speed * delta * 1.414)
	var result = get_world_2d().direct_space_state.intersect_shape(shape_query)
	return result.size() == 0

func animate():
	if movement_direction == Vector2.ZERO:
		sprite.stop()
	else:
		sprite.flip_h = (movement_direction == Vector2.LEFT)
		sprite.play()

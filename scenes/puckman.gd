extends SpeedyCharacterBody2D

class_name PuckMan

const GridUtils = preload("res://scenes/utils/grid_utils.gd")
var grid_utils = GridUtils.new()

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionHelper2D = $CollisionShape2D

var movement_direction = Vector2.ZERO
var next_movement_direction = Vector2.ZERO

func select_next_cell_to_target(target_position: Vector2) -> Vector2i:
	var current_cell = grid_utils.get_cell_from_position(position)
	var target_cell = grid_utils.get_cell_from_position(target_position)

	var up_cell = Vector2i(current_cell.x, current_cell.y - 1)
	var left_cell = Vector2i(current_cell.x - 1, current_cell.y)
	var down_cell = Vector2i(current_cell.x, current_cell.y + 1)
	var right_cell = Vector2i(current_cell.x + 1, current_cell.y)

	var delta: float = 0.0166666666667

	var candidates = []
	var message = ""

	message = message + "ᗧ (%s, %s) → (%s, %s) [%.2f] " % [
		current_cell.x, current_cell.y,
		target_cell.x, target_cell.y,
		current_cell.distance_to(target_cell)
	]

	if collision_shape_2d.can_move_in_direction(Vector2.UP, delta):
		message = message + "↑ %.2f " % [ up_cell.distance_to(target_cell) ]
		candidates.push_back([up_cell, up_cell.distance_to(target_cell) ])
	if collision_shape_2d.can_move_in_direction(Vector2.LEFT, delta):
		message = message + "← %.2f " % [ left_cell.distance_to(target_cell) ]
		candidates.push_back([ left_cell, left_cell.distance_to(target_cell) ])
	if collision_shape_2d.can_move_in_direction(Vector2.DOWN, delta):
		message = message + "↓ %.2f " % [ down_cell.distance_to(target_cell) ]
		candidates.push_back([ down_cell, down_cell.distance_to(target_cell) ])
	if collision_shape_2d.can_move_in_direction(Vector2.RIGHT, delta):
		message = message + "→ %.2f " % [ right_cell.distance_to(target_cell) ]
		candidates.push_back([ right_cell, right_cell.distance_to(target_cell) ])

	print_debug(message)

	candidates.sort_custom(sort_by_distance)
	return candidates[0][0]

func sort_by_distance(left: Array, right: Array) -> bool:
	return left[1] < right[1]

func _process(_delta: float):
	if Input.is_action_just_pressed("debug"):
		if velocity == Vector2.ZERO:
			var _cell = select_next_cell_to_target(Vector2(240, -304))

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

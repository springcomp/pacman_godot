extends SpeedyCharacterBody2D

class_name Ghost

const GridUtils = preload("res://scenes/utils/grid_utils.gd")

signal on_direction_changed(direction: Vector2)

@export var movement_targets: MovementTargets
@export var tilemap_layer: TileMapLayer

@onready var body_sprite_2d: AnimatedSprite2D = $BodySprite2D
@onready var collision_shape_2d: CollisionHelper2D = $CollisionShape2D
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D

var direction = Vector2.ZERO
var current_scatter_index: int = 1

var grid_utils = GridUtils.new()

func _ready():
    call_deferred("setup")
    
func setup():
    var map = tilemap_layer.get_navigation_map()

    navigation_agent_2d.path_desired_distance = 4.0
    navigation_agent_2d.target_desired_distance = 4.0
    navigation_agent_2d.set_navigation_map(map)
    navigation_agent_2d.target_reached.connect(on_target_reached)

    NavigationServer2D.agent_set_map(navigation_agent_2d.get_rid(), map)

    scatter()
    
func _physics_process(delta: float) -> void:
    if not navigation_agent_2d.is_navigation_finished():
        var next_position = navigation_agent_2d.get_next_path_position()
        move(next_position, delta)
        body_sprite_2d.play()
    else:
        body_sprite_2d.stop()
    
func move(next_position: Vector2, delta: float):
    var current_position = global_position
    var new_direction = (next_position - current_position).normalized()
    var new_path_direction = get_path_direction(new_direction)
    if new_path_direction != direction:
        self.direction = new_path_direction
        on_direction_changed.emit(direction)

    var distance = direction * speed * delta
    self.position += distance

func get_path_direction(dir: Vector2) -> Vector2:
    var magnitudes = [
        [ Vector2.UP,    Vector2.UP.dot(dir) ],
        [ Vector2.LEFT,  Vector2.LEFT.dot(dir) ],
        [ Vector2.RIGHT, Vector2.RIGHT.dot(dir) ],
        [ Vector2.DOWN,  Vector2.DOWN.dot(dir) ]
    ]
    magnitudes.sort_custom(sort_by_magnitude_reversed)
    return magnitudes[0][0]

func sort_by_magnitude_reversed(left: Array, right: Array) -> bool:
    return (left[1] > right[1])

func scatter():
    update_target_position()

func scatter2():
    var target = get_current_target()
    var target_cell = grid_utils.get_cell_from_position(target.position)
    print_debug("target: (%s, %s)" % [ target_cell.x, target_cell.y ])

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

    message = message + "ᗣ (%s, %s) → (%s, %s) [%.2f] " % [
        current_cell.x, current_cell.y,
        target_cell.x, target_cell.y,
        current_cell.distance_to(target_cell)
    ]

    if can_move_in_direction(Vector2.UP, delta):
        message = message + "↑ %.2f " % [ up_cell.distance_to(target_cell) ]
        candidates.push_back([up_cell, up_cell.distance_to(target_cell) ])
    if can_move_in_direction(Vector2.LEFT, delta):
        message = message + "← %.2f " % [ left_cell.distance_to(target_cell) ]
        candidates.push_back([ left_cell, left_cell.distance_to(target_cell) ])
    if can_move_in_direction(Vector2.DOWN, delta):
        message = message + "↓ %.2f " % [ down_cell.distance_to(target_cell) ]
        candidates.push_back([ down_cell, down_cell.distance_to(target_cell) ])
    if can_move_in_direction(Vector2.RIGHT, delta):
        message = message + "→ %.2f " % [ right_cell.distance_to(target_cell) ]
        candidates.push_back([ right_cell, right_cell.distance_to(target_cell) ])

    print_debug(message)

    candidates.sort_custom(sort_by_distance)
    return candidates[0][0]

func sort_by_distance(left: Array, right: Array) -> bool:
    return left[1] < right[1]

func can_move_in_direction(dir: Vector2, delta: float) -> bool:
    if dir == -direction:
        return false
    return collision_shape_2d.can_move_in_direction(dir, delta)

func get_current_target() -> Node2D:
    return movement_targets.scatter_targets[current_scatter_index]

func update_target_position():
    var target = get_current_target()
    var next_cell = select_next_cell_to_target(target.position)
    var next_target = grid_utils.get_position_from_cell(next_cell)

    set_target_position(next_target)

func set_target_position(target_position: Vector2):
    navigation_agent_2d.target_position = target_position

func select_next_target():
    ## current_scatter_index += 1
    ## if current_scatter_index >= movement_targets.scatter_targets.size():
    ## 	current_scatter_index = 0

    call_deferred("update_target_position")

func on_target_reached():
    print_debug("target reached")
    select_next_target();

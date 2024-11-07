extends StaticBody2D

class_name Ghost

@export var speed: float = 300
@export var movement_targets: MovementTargets
@export var tilemap_layer: TileMapLayer

@onready var body_sprite_2d: AnimatedSprite2D = $BodySprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D

var current_scatter_index: int = 1

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
	var direction = (next_position - current_position).normalized()
	var distance = direction * speed * delta
	position += distance

func scatter():
	update_target_position()

func get_current_target() -> Node2D:
	return movement_targets.scatter_targets[current_scatter_index]

func update_target_position():
	var target = get_current_target()
	set_target_position(target.position)

func set_target_position(target_position: Vector2):
	navigation_agent_2d.target_position = target_position

func select_next_target():
	current_scatter_index += 1
	if current_scatter_index >= movement_targets.scatter_targets.size():
		current_scatter_index = 0

	call_deferred("update_target_position")

func on_target_reached():
	## adjust the final position of the ghost
	## to prevent collision with walls

	position = get_current_target().position

	select_next_target();

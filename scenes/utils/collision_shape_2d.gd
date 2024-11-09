extends CollisionShape2D

class_name CollisionHelper2D

var speed: float
var shape_query: PhysicsShapeQueryParameters2D

func _ready():
	var parent = get_parent() as SpeedyCharacterBody2D
	speed = parent.speed

	shape_query = PhysicsShapeQueryParameters2D.new()
	shape_query.shape = self.shape
	shape_query.collide_with_areas = false
	shape_query.collide_with_bodies = true
	shape_query.collision_mask = 2

func can_move_in_direction(dir: Vector2, delta: float) -> bool:
	shape_query.transform = global_transform.translated(dir * speed * delta * 2)
	var result = get_world_2d().direct_space_state.intersect_shape(shape_query)
	return result.size() == 0

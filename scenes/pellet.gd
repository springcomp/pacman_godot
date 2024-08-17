extends Area2D

class_name Pellet

signal on_pellet_eaten(pellet: Pellet)

@export var is_power_pill: bool = false

func _on_body_entered(body: Node2D) -> void:
	queue_free()
	if body is PuckMan:
		on_pellet_eaten.emit(self)
		if is_power_pill:
			pass

extends Node

@export var node: Node2D

func _process(_delta: float) -> void:
	if node.global_position.x > 480:
		node.global_position.x = -480
	if node.global_position.x < -480:
		node.global_position.x = 480

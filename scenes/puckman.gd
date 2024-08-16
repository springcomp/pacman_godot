extends StaticBody2D

class_name PuckMan

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _process(delta: float) -> void:
	if Input.is_action_pressed("move_right"):
		sprite.rotation = 0
		sprite.flip_h = false
		sprite.play()
	elif Input.is_action_pressed("move_left"):
		sprite.rotation = 0
		sprite.flip_h = true
		sprite.play()
	elif Input.is_action_pressed("move_up"):
		sprite.rotation = -PI/2
		sprite.flip_h = false
		sprite.play()
	elif Input.is_action_pressed("move_down"):
		sprite.rotation = PI/2
		sprite.flip_h = false
		sprite.play()		
	else:
		sprite.stop()	

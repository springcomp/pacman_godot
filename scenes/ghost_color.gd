extends AnimatedSprite2D

var ghost_parameters: Dictionary = {
	Blinky = [ Color.CRIMSON ],
	Inky = [ Color.TURQUOISE ],
	Clyde = [ Color.SANDY_BROWN ],
	Pinky = [ Color.VIOLET ],
}

func _ready() -> void:
	var parent = get_parent()
	var ghost_color = ghost_parameters[parent.name][0]
	self.modulate = ghost_color

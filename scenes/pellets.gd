extends Node

signal on_game_won()

var eaten_pellets_count: int = 0
var total_pellets_count: int

func _ready():
	var pellets = get_children() as Array[Pellet]
	total_pellets_count = pellets.size()
	for pellet in pellets:
		pellet.on_pellet_eaten.connect(on_pellet_eaten)

func on_pellet_eaten(_pellet: Pellet):
		eaten_pellets_count += 1
		if eaten_pellets_count == total_pellets_count:
			on_game_won.emit()

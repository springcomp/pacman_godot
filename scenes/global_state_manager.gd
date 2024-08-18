extends Node

class_name GlobalStateManager

const GhostUtils = preload("res://scenes/utils/ghost_state.gd")

signal on_state_changed(new_state: GhostUtils.GhostState)

@onready var state_timer: Timer = $StateTimer

## timings for state change
## alternating between SCATTER and CHASE
## last two timings repeat ad finitum 
const timings = [
	7,
	20,
	7,
	20,
	5,
	20,
]

var current_timing_index: int = -1
var current_state = GhostUtils.GhostState.SCATTER

func _ready():
	change_state()
	
func change_state():
	on_state_changed.emit(current_state)
	reset_timer()
	current_state = 1 - current_state as GhostUtils.GhostState

func reset_timer():
	current_timing_index += 1
	if current_timing_index == timings.size():
		current_timing_index = timings.size() - 2
	
	var wait_time = timings[current_timing_index]
	state_timer.wait_time = wait_time
	state_timer.start()

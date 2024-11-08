const CELL_WIDTH = 32
const CELL_HEIGHT = 32

const GRID_TOP = -496
const GRID_LEFT = -496

func get_cell_from_position(position: Vector2) -> Vector2i:
	var x = (int(snapped(position.x, 16)) - GRID_LEFT) / CELL_WIDTH
	var y = (int(snapped(position.y, 16)) - GRID_TOP) / CELL_HEIGHT

	var cell = Vector2i(x, y)
	return cell

func get_position_from_cell(cell: Vector2i) -> Vector2:
	var x = cell.x * CELL_WIDTH + GRID_LEFT
	var y = cell.y * CELL_HEIGHT + GRID_TOP

	var position = Vector2(x, y)
	return position
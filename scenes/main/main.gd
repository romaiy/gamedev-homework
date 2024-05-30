extends Node2D

const grid_size = Vector2(320, 320)
const cell_size = Vector2(32, 32)

const srv = Vector2(Main.cell_size.x, 0) # screen-right-vector
const sdv = Vector2(0, Main.cell_size.y)

const cell_amount = Vector2(grid_size.x / cell_size.x, grid_size.y / cell_size.y)

const grid_offset = Vector2(800, 352)

const action_colors = {
	'plant': '#009632',
	'weed': '#e69500',
	'water': '#273fda',
	'disabled': '#bdbdbd'
}

var current_action = 'plant'

var is_out_of_grid = false

func _ready():
	pass

func _process(_delta):
	pass
	
func _draw() -> void:
	var screen_size: Vector2 = get_viewport_rect().size
	
	draw_rect(Rect2(Vector2(0, 0), screen_size), "#FFFFFF")
	
	for i in range(cell_amount.x + 1):
		var from := Vector2(i * cell_size.x, 0) + grid_offset
		var to := Vector2(i * cell_size.x, grid_size.y) + grid_offset
		draw_line(from, to, '#bdbdbd')
		
	for i in range(cell_amount.y + 1):
		var from := Vector2(0, cell_size.y * i) + grid_offset
		var to := Vector2(grid_size.x, cell_size.y * i) + grid_offset
		draw_line(from, to, '#bdbdbd')

func cell2pixel(cell:Vector2):
	return srv*cell.x + sdv*cell.y

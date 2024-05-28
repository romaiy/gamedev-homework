extends Node2D

var current_action_color = Main.action_colors.plant
var temp_action = 'plant'

var active_cell_points = []

func _ready() -> void:
	pass 

func _process(_delta) -> void:
	pass

func _draw() -> void:
	if (active_cell_points.size()):
		draw_multiline(active_cell_points, current_action_color)

func draw_active_cell(cell:Vector2):
	active_cell_points = PackedVector2Array([
		Main.cell2pixel(cell), # Левый верхний угол
		Main.cell2pixel(cell) + Main.srv, # Прибавили правый базис, правый верхний угол
		Main.cell2pixel(cell), # Левый верхний угол
		Main.cell2pixel(cell) + Main.sdv, # Прибавили нижний базис, левый нижний угол
		Main.cell2pixel(cell)+ Main.srv + Main.sdv, # Прибавили оба базиса, правый нижний угол
		Main.cell2pixel(cell) + Main.sdv, # Прибавили нижний базис, левый нижний угол
		Main.cell2pixel(cell) + Main.srv, # Прибавили правый базис, правый верхний угол
		Main.cell2pixel(cell) + Main.srv + Main.sdv, # Прибавили оба базиса, правый нижний угол
	])
	queue_redraw()

func _on_user_target_cell_change(pos:Vector2) -> void:
	var x = floor(pos.x/Main.cell_size.x)
	var y = floor(pos.y/Main.cell_size.y)
	
	if (pos.x >= Main.grid_offset.x and pos.x <= Main.grid_offset.x + Main.grid_size.x and 
		pos.y >= Main.grid_offset.y and pos.y <= Main.grid_offset.y + Main.grid_size.y):
		Main.current_action = temp_action
		Main.is_out_of_grid = false
	else:
		Main.is_out_of_grid = true
		Main.current_action = 'disabled'
	
	current_action_color = Main.action_colors[Main.current_action]
	
	draw_active_cell(Vector2(x, y))


func _on_user_user_action_change():
	temp_action = Main.current_action
	var color = 'disabled' if Main.is_out_of_grid else Main.current_action
	
	current_action_color = Main.action_colors[color]
	queue_redraw()

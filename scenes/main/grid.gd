extends Node2D

var current_action_color = Main.action_colors.plant

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
	draw_active_cell(Vector2(x, y))


func _on_user_user_action_change(action_type: String):
	current_action_color = Main.action_colors[action_type]
	queue_redraw()

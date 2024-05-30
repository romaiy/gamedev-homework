extends Node2D

@export var plant_class: Resource

var weeded_beds = []
var plants_beds = []
var watered_beds = []

signal action_is_done

var active_cell_points = null

func _ready() -> void:
	pass 

func _process(_delta) -> void:
	pass

func _draw() -> void:
	if (weeded_beds.size() or plants_beds.size() or watered_beds.size()):
		for vector in weeded_beds:
			draw_rect(
			Rect2(vector, Main.cell_size), 
			Main.action_colors.weed)
		for vector in plants_beds:
			draw_rect(
			Rect2(vector, Main.cell_size), 
			Main.action_colors.plant)
		for vector in watered_beds:
			draw_rect(
			Rect2(vector, Main.cell_size), 
			Main.action_colors.water)

func add_active_cell(cell:Vector2):
	active_cell_points = Main.cell2pixel(cell)
	
	match Main.current_action:
		'plant': add_plant()
		'weed': add_weed() 
		'water': add_water()
		
	queue_redraw()

func add_plant():
	if (!plants_beds.has(active_cell_points) and weeded_beds.has(active_cell_points)):
		plants_beds.append(active_cell_points)
		action_is_done.emit('plant')
		
		if plant_class:
			var plant = plant_class.new(active_cell_points.x, active_cell_points.y)
			add_child(plant)

func add_weed():
	if (!weeded_beds.has(active_cell_points)):
		weeded_beds.append(active_cell_points)
		action_is_done.emit('weed')

func add_water():
	if (!watered_beds.has(active_cell_points)):
		watered_beds.append(active_cell_points)
		action_is_done.emit('water')

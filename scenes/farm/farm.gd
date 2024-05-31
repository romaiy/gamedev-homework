extends Node2D

@export var plant_class: Resource

var weeded_beds = []
var plants_beds = []
var watered_beds = []

signal action_is_done
signal get_harves

var active_cell_points = null

func _ready() -> void:
	pass 

func _process(_delta) -> void:
	pass

func _draw() -> void:
	if (weeded_beds.size() or plants_beds.size() or watered_beds.size()):
		for vector in weeded_beds:
			draw_rect(
			Rect2(vector + Vector2(0, 2), Main.correction_cell_size), 
			Main.action_colors.weed)
		#for vector in watered_beds:
			#draw_rect(
			#Rect2(vector, Main.cell_size), 
			#Main.action_colors.water)

func add_active_cell(cell:Vector2, charges):
	active_cell_points = Main.cell2pixel(cell)
	
	match Main.current_action:
		'plant': add_plant(charges)
		'weed': add_weed(charges) 
		'water': add_water(charges)
		
	queue_redraw()

func add_plant(charges):
	var plants_coords = plants_beds.map(func(plant): return plant.coords)
	
	if (!plants_coords.has(active_cell_points) and 
		weeded_beds.has(active_cell_points) and
		charges != 0):
		var id = IdGenerator.generate_id()
		var plant = plant_class.new(id, active_cell_points.x, active_cell_points.y)
		
		plants_beds.append({'coords': active_cell_points, 'id': id, 'plant': plant})
		
		add_child(plant)
		
		action_is_done.emit('plant')
		
	elif(plants_coords.has(active_cell_points)):
		var index = plants_coords.find(active_cell_points)
		handle_harvest(index)

func handle_harvest(plant_index):
	var plant = plants_beds[plant_index].plant
	
	var cycles = plant.get_cycles()
	var coords = plant.get_coords()
	
	var weed_index = weeded_beds.find(coords)
	
	if cycles.total == cycles.current:
		plant.harvest()
		
		plants_beds.pop_at(plant_index)
		weeded_beds.pop_at(weed_index)
		
		get_harves.emit(2)
		

func add_weed(charges):
	if (!weeded_beds.has(active_cell_points) and charges != 0):
		weeded_beds.append(active_cell_points)
		action_is_done.emit('weed')

func add_water(charges):
	var plants_coords = plants_beds.map(func(plant): return plant.coords)
	
	if (plants_coords.has(active_cell_points) and charges != 0):
		var index = plants_coords.find(active_cell_points)
		plants_beds[index].plant.water()	
		action_is_done.emit('water')
	elif charges != 0:
		action_is_done.emit('water')

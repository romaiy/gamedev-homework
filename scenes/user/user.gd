extends Node2D

signal target_cell_change
signal user_action_change
signal user_clicked

signal change_hud

var max_weed_charges = 5
var current_weed_charges = max_weed_charges

var max_plant_charges = 5
var current_plant_charges = max_plant_charges

var max_water_charges = 10
var current_water_charges = max_water_charges

func _ready():
	change_hud.emit('weed', current_weed_charges, max_weed_charges)
	change_hud.emit('plant', current_plant_charges, max_plant_charges)
	change_hud.emit('water', current_water_charges, max_water_charges)

func _process(_delta):
	if Input.is_action_pressed("plant"):
		Main.current_action = 'plant'
		user_action_change.emit()
		
	if Input.is_action_pressed("weed"):
		Main.current_action = 'weed'
		user_action_change.emit()
		
	if Input.is_action_pressed("water"):
		Main.current_action = 'water'
		user_action_change.emit()

func _input(event) -> void:
	if event is InputEventMouseMotion:
		target_cell_change.emit(event.position)
		
	elif Input.is_action_pressed("left_mouse_down"):
		if "position" in event:
			handle_button_click(event.position)
		
func handle_button_click(pos: Vector2):
	var x = floor(pos.x/Main.cell_size.x)
	var y = floor(pos.y/Main.cell_size.y)

	match Main.current_action:
		'plant': handle_plant(Vector2(x, y))
		'weed': handle_weed(Vector2(x, y))
		'water': handle_water(Vector2(x, y))

func handle_plant(pos: Vector2):
	user_clicked.emit(pos, current_plant_charges)
	
func handle_weed(pos: Vector2):
	user_clicked.emit(pos, current_weed_charges)

func handle_water(pos: Vector2):
	user_clicked.emit(pos, current_water_charges)

func weed_charge_change(current_charges):
	if (current_charges > 0):
		max_weed_charges += 1
	
	if (current_weed_charges + current_charges > max_weed_charges):
		current_weed_charges += max_weed_charges - current_weed_charges
	else:	
		current_weed_charges += current_charges

	change_hud.emit('weed', current_weed_charges, max_weed_charges)
	
func plant_charge_change(current_charges):
	if (current_charges > 0):
		max_plant_charges += 1
	
	if (current_plant_charges + current_charges > max_plant_charges):
		current_plant_charges += max_plant_charges - current_plant_charges
	else:	
		current_plant_charges += current_charges
	
	change_hud.emit('plant', current_plant_charges, max_plant_charges)
	
func water_charge_change(current_charges):
	current_water_charges += current_charges
	
	change_hud.emit('water', current_water_charges, max_water_charges)

func _on_weed_recharge_timer_timeout():
	current_weed_charges += 1
	change_hud.emit('weed', current_weed_charges)
	
	if current_weed_charges < max_weed_charges:
		$WeedRechargeTimer.start()

func _on_farm_action_is_done(action_type):
	match action_type:
		'weed': weed_charge_change(-1)
		'plant': plant_charge_change(-1)
		'water': water_charge_change(-1)


func _on_farm_get_harves(harvest_count):
	plant_charge_change(harvest_count)
	weed_charge_change(harvest_count)


func _on_hud_get_water():
	current_water_charges = 10
	change_hud.emit('water', current_water_charges, max_water_charges)

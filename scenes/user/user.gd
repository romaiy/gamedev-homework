extends Node2D

signal target_cell_change
signal user_action_change
signal user_clicked

signal change_hud

var max_weed_charges = 5
var current_weed_charges = max_weed_charges

var max_plant_charges = 5
var current_plant_charges = max_plant_charges

func _ready():
	change_hud.emit('weed', current_weed_charges)
	change_hud.emit('plant', current_plant_charges)

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
		handleButtonClick(event.position)
		
func handleButtonClick(pos: Vector2):
	var x = floor(pos.x/Main.cell_size.x)
	var y = floor(pos.y/Main.cell_size.y)

	match Main.current_action:
		'plant': handlePlant(Vector2(x, y))
		'weed': handleWeed(Vector2(x, y))
		'water': handleWater(Vector2(x, y))

func handlePlant(pos: Vector2):
	if current_plant_charges == 0: return
	user_clicked.emit(pos)
	
func handleWeed(pos: Vector2):
	if current_weed_charges == 0: return
	user_clicked.emit(pos)

func handleWater(pos: Vector2):
	user_clicked.emit(pos)

func weed_charge_change():
	current_weed_charges -= 1
	# $WeedRechargeTimer.start()
	change_hud.emit('weed', current_weed_charges)
	
func plant_charge_change():
	current_plant_charges -= 1
	# $WeedRechargeTimer.start()
	change_hud.emit('plant', current_plant_charges)

func _on_weed_recharge_timer_timeout():
	current_weed_charges += 1
	change_hud.emit('weed', current_weed_charges)
	
	if current_weed_charges < max_weed_charges:
		$WeedRechargeTimer.start()

func _on_farm_action_is_done(action_type):
	match action_type:
		'weed': weed_charge_change()
		'plant': plant_charge_change()

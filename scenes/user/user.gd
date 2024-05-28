extends Node2D

signal target_cell_change
signal user_action_change
signal user_clicked

signal user_weeded

var max_weed_charges = 5
var current_weed_charges = max_weed_charges

func _ready():
	user_weeded.emit(current_weed_charges)

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
	user_clicked.emit(pos)
	
func handleWeed(pos: Vector2):
	if current_weed_charges == 0: return
	current_weed_charges -= 1
	$WeedRechargeTimer.start()
	user_weeded.emit(current_weed_charges)
	user_clicked.emit(pos)

func handleWater(pos: Vector2):
	user_clicked.emit(pos)


func _on_weed_recharge_timer_timeout():
	current_weed_charges += 1
	user_weeded.emit(current_weed_charges)
	
	if current_weed_charges < max_weed_charges:
		$WeedRechargeTimer.start()

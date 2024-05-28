extends Node2D

signal target_cell_change
signal user_action_change
signal user_clicked

func _ready():
	pass 

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
	user_clicked.emit(pos)

func handleWater(pos: Vector2):
	user_clicked.emit(pos)

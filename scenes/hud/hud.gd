extends CanvasLayer

signal get_water
# Called when the node enters the scene tree for the first time.
func _ready():
	 # Replace with function body.
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func update_charges(chargesType: String, charges, max_charges):
	var node_path = "Header/" + chargesType + "/ChargesCount"
	var charges_label = get_node(node_path)
	charges_label.text = str(charges, ' / ', max_charges)


func _on_user_change_hud(chargesType: String, charges, max_charges):
	update_charges(chargesType, charges, max_charges)


func _on_texture_button_pressed():
	get_water.emit()

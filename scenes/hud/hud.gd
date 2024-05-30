extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	 # Replace with function body.
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func update_charges(chargesType: String, charges):
	var node_path = "Header/" + chargesType + "/ChargesCount"
	var charges_label = get_node(node_path)
	charges_label.text = str(charges, ' / ', 5)


func _on_user_change_hud(chargesType: String, charges):
	update_charges(chargesType, charges)

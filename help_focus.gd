extends HBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


var focused_node
func _process(_delta):
	var new_focused_node = get_viewport().gui_get_focus_owner()
	if new_focused_node != focused_node:
		focused_node = new_focused_node
		if(focused_node is Button):
			show()
		else:
			hide()
	if Input.is_action_pressed("ui_accept"):
		$SelectTexture.hide()
		$SelectTexturePressed.show()
	else:
		$SelectTexturePressed.hide()
		$SelectTexture.show()
	if Input.is_action_pressed("ui_cancel"):
		$CancelTexture.hide()
		$CancelTexturePressed.show()
	else:
		$CancelTexture.show()
		$CancelTexturePressed.hide()

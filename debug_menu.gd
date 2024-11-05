extends Panel

var precedentInv:Dictionary={}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in Globals.items.keys():
		var texture = Globals.preload_res(Globals.items[i]["texture"])#await Globals.preload_res(Globals.items[i]["texture"])
		$VBoxContainer/HBoxContainer/OptionButton.add_icon_item(texture,i+"-"+Globals.items[i]["name"])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if ! Globals.getPlayer():return
	if Globals.playerInventory.hash()!=precedentInv.hash():
		print("updated")
		print(precedentInv)
		$VBoxContainer/HBoxContainer2/OptionButton.clear()
		for i in Globals.getPlayer().get_full_inv():
			var texture = Globals.preload_res(Globals.items[i["item"]]["texture"])
			$VBoxContainer/HBoxContainer2/OptionButton.add_icon_item(texture,i["item"]+"-"+Globals.items[i["item"]]["name"]+"("+str(i["quantity"]))
	if Input.is_action_just_pressed("debugOpen"):
		visible=!visible


func _on_hit_button_pressed() -> void:
	Globals.getPlayer().hit(1)


func _on_button_pressed() -> void:
	Globals.getPlayer().inventory_add_item(Globals.items.keys()[$VBoxContainer/HBoxContainer/OptionButton.selected],1)


func _on_rem_item_button_pressed() -> void:
	print("globals",Globals.playerInventory,"\ninv",precedentInv)
	Globals.getPlayer().inventory_rem_item(Globals.playerInventory.bagSlots[$VBoxContainer/HBoxContainer2/OptionButton.selected]["item"],1)

func _on_particle_button_pressed() -> void:
	pass # Replace with function body.

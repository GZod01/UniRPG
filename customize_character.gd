extends Control

var valarray=[]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var storySaveIndex:int=2
	var curIndex=0
	for i in range(2,5+1):
		for j in range(1,8+1):
			$Panel/HBoxContainer/OptionButton.add_item("%d - %d" % [i,j])
			valarray.append("%d%d" % [i,j])
			if int("%d%d" % [i,j]) == Globals.storySave.selectedSkin:
				storySaveIndex=curIndex
			curIndex+=1
	$Panel/HBoxContainer/OptionButton.select(storySaveIndex)
	_on_option_button_item_selected(storySaveIndex)
	$Panel/HBoxContainer/OptionButton.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_option_button_item_selected(index: int) -> void:
	var sSelectedSkin = valarray[index]
	if int(sSelectedSkin[0])<2 or int(sSelectedSkin[0])>5 or int(sSelectedSkin[1])<1 or int(sSelectedSkin[1])>8:
		sSelectedSkin=str(Globals.DEFAULT_SKIN)
	$Control/FantasyCharactersAnimatedSprite.chara_no1=int(sSelectedSkin[0])
	$Control/FantasyCharactersAnimatedSprite.chara_no2=int(sSelectedSkin[1])


func _on_cancel_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")



func _on_accept_button_pressed() -> void:
	var sSelectedSkin = valarray[$Panel/HBoxContainer/OptionButton.selected]
	if int(sSelectedSkin[0])<2 or int(sSelectedSkin[0])>5 or int(sSelectedSkin[1])<1 or int(sSelectedSkin[1])>8:
		sSelectedSkin=str(Globals.DEFAULT_SKIN)
	Globals.storySave.selectedSkin=int(sSelectedSkin)
	get_tree().change_scene_to_file("res://main_menu.tscn")

extends Control

var previous_focus:Control
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _on_continue_button_pressed() -> void:
	unpause()

func pause():
	show()
	previous_focus=get_viewport().gui_get_focus_owner()
	$Panel/VBoxContainer/ContinueButton.grab_focus()
	get_tree().paused=true

func unpause():
	if previous_focus!=null:
		previous_focus.grab_focus()
	get_tree().paused=false
	hide()

func togglePause():
	if get_tree().paused:
		unpause()
	else:
		pause()

func _on_main_menu_button_pressed() -> void:
	Globals.save_game()
	unpause();
	get_tree().change_scene_to_file("res://main_menu.tscn")

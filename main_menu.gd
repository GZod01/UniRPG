extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Panel/MarginContainer/VBoxContainer/Button.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://world.tscn")
	print("h")


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_custom_character_button_pressed() -> void:
	get_tree().change_scene_to_file("res://customize_character.tscn")

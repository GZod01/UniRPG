extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func sth_enter(sth: Node2D) -> void:
	if "isPlayer" in sth and sth.isPlayer==true:
		$AnimatedSprite2D.play("open")
		sth.show_change_map_proposition("Voulez vous entrer dans la maison?",("res://player_house_map.tscn"))

func sth_exit(sth: Node2D) -> void:
	if "isPlayer" in sth and sth.isPlayer==true:
		$AnimatedSprite2D.play("default")
		sth.hide_change_map_proposition()

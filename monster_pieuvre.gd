extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func sth_enter(sth: Node2D) -> void:
	if "isPlayer" in sth and sth.isPlayer==true:
		sth.show_change_map_proposition("Voulez vous vous battre?",("res://Combats/combat_pieuvre.tscn"),"frommonsterpieuvre")

func sth_exit(sth: Node2D) -> void:
	if "isPlayer" in sth and sth.isPlayer==true:
		sth.hide_change_map_proposition()

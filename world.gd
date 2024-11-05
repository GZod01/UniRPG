extends Node2D

@export var map_name=""

@export var map_player_zoom=3
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	change_map(("res://player_house_map.tscn"))


func getPlayer()->CharacterBody2D:
	return $Player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func change_map(scs:String,fromwhere:String=""):
	map_name=scs.trim_prefix("res://").trim_suffix(".tscn")
	var sc:PackedScene=Globals.preload_res(scs)#await Globals.preload_res(scs)
	for n in $Map.get_children(true):
		n.queue_free()
	print(sc)
	var newn:Node
	if sc.can_instantiate():
		print("can instantiate")
		newn= sc.instantiate()#await sc.instantiate()
	else:
		
		return null
	print(newn)
	$Map.add_child(newn)
	if newn.has_node("playerspawn"+fromwhere):
		print(newn.get_node("playerspawn"+fromwhere).global_position)
		$Player.global_position= newn.get_node("playerspawn"+fromwhere).global_position
		print($Player.global_position)
	elif newn.has_node("playerspawn"):
		$Player.global_position= newn.get_node("playerspawn").global_position
	else:
		$Player.global_position=Vector2(0,0)

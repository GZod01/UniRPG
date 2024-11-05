extends Area2D

var slash_callback:Callable=Callable(func() -> void:pass)
var isslashing:bool=false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.body_entered.connect(on_sth_entered)
	self.area_entered.connect(on_sth_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if isslashing:
		rotation_degrees+=delta*1000
		if rotation_degrees>360:
			rotation_degrees=0
			finish_slash()

func slash(item_id:String):
	print("slash")
	print("item:",item_id)
	if !Globals.items[item_id].usable:
		print("oh")
		return
	self.show()
	print("yeah")
	$CollisionShape2D.disabled=false
	var item_texture = Globals.preload_res(Globals.items[item_id].texture)
	$Sprite2D.texture=item_texture
	print(item_texture)
	print($Sprite2D.texture)
	isslashing=true
	self.slash_callback=Globals.items[item_id].something_enter_callback
	

func on_sth_entered(sth:Node2D):
	print("oh")
	if !isslashing:return
	if "isPlayer" in sth and sth.isPlayer:
		return
	print("yeah")
	if self.slash_callback.call(get_parent(),sth)!=false:
		finish_slash()
func finish_slash():
	isslashing=false
	$CollisionShape2D.disabled=true
	self.hide()

extends Area2D

var playerinside=null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.area_entered.connect(sth_enter)
	self.body_entered.connect(sth_enter)
	self.body_exited.connect(sth_exit)
	self.area_exited.connect(sth_exit)

func sth_enter(sth):
	if "isPlayer" in sth and sth.isPlayer:
		$Label.show()
		playerinside=sth
func sth_exit(sth):
	if "isPlayer" in sth and sth.isPlayer:
		$Label.hide()
		playerinside=null
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func _input(event:InputEvent):
	if Dialogic.current_timeline != null or playerinside==null:
		return

	if event is InputEventKey and event.keycode == KEY_ENTER and event.pressed:
		Dialogic.start('unirpg')
		get_viewport().set_input_as_handled()

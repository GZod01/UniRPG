@tool
extends SubViewport

@export var labelsettings:LabelSettings:
	set(value):
		labelsettings=value
		setlabel()
@export var text: String="Hello" :
	set(value):
		text=value
		setlabel()

func _enter_tree() -> void:
	setlabel()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setlabel()

func setlabel()->void:
	$Label.label_settings=labelsettings
	$Label.text=text
	print("hello")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

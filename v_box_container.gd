extends VBoxContainer

var previous_hash:int=-1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if previous_hash!=Globals.getKeySettings().hash():
		var keytexts=[]
		for i in Globals.actionsToShowInHelp:
			var txt = Globals.actionsKeysDescriptions[i]
			var keys_list = Globals.getKeySettings()[i]
			txt += ": ["+(",".join(keys_list))+"]"
			keytexts.append(txt)
		$Label2.text = "---\n"+("\n-".join(keytexts))+"\n---"
		previous_hash=Globals.getKeySettings().hash()
		

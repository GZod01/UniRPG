extends Area2D
var playernode=null



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func sth_enter(sth: Node2D) -> void:
	if "isPlayer" in sth and sth.isPlayer==true:
		$AnimatedSprite2D.play("open")
		playernode=sth
		sth.show_proposition("Voulez vous dormir",Callable(self,"sleep"),"Dormir ZZZ","Déplacez vous pour annuler",true)
func sleep():
			print("hello world from here")
			print(self)
			print("ho ye")
			print(self.playernode)
			print("called by ")
			print(self)
			playernode.get_node("AnimatedSprite2D").play("die")
			playernode.get_node("AnimatedSprite2D").flip_h=true;
func sth_exit(sth: Node2D) -> void:
	if "isPlayer" in sth and sth.isPlayer==true:
		$AnimatedSprite2D.play("default")
		sth.refuse_proposition()

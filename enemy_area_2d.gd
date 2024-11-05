extends Area2D

@export var degats_petite_attaque:float=1
@export var degats_grosse_attaque:float=10
@export var cooldown_petite_attaque:float=2
@export var cooldown_grosse_attaque:float=10
@export var speed:float=100.0
@export var lives:int = 5
var die:bool=false
var curplayer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play("default")
	$PetitCooldown.wait_time=cooldown_petite_attaque
	$GrosCooldown.wait_time=cooldown_grosse_attaque
	self.area_entered.connect(sth_enter)
	self.body_entered.connect(sth_enter)
	self.area_exited.connect(sth_exit)
	self.body_exited.connect(sth_exit)
	$AnimatedSprite2D.animation_finished.connect(animation_finished)
	$PetitCooldown.timeout.connect(petiteattaque)
	$GrosCooldown.timeout.connect(grosseattaque)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if die:return
	var dir = global_position.direction_to(get_tree().current_scene.get_node("Player").global_position)
	var v = dir*speed*delta
	global_position+=v

func animation_finished():
	if die:
		get_tree().current_scene.getPlayer().show_proposition(
			"Vous avez vaincu le monstre! Félicitation, retournez au village voir le maire pour recevoir votre récompense!",
			change_scene_to_wow,"Retourner au village",null,true)
func change_scene_to_wow():
	Dialogic.VAR.set_variable("PieuvreKilledAmount",int(Dialogic.VAR.get_variable("PieuvreKilledAmount"))+1)
	get_tree().current_scene.change_map("res://player_city_map.tscn","pieuvrevictoire")
	queue_free()
func hit(amount:int=1):
	lives-=amount
	if lives <=0:
		die=true
		$AnimatedSprite2D.play("die")

func sth_enter(sth:Node2D):
	if die:return
	if "isPlayer" in sth and sth.isPlayer:
		curplayer = sth
		petiteattaque()
		$GrosCooldown.start()
func petiteattaque():
	if die:return
	if curplayer==null:return
	curplayer.hit(degats_petite_attaque)
	$PetitCooldown.start()
func grosseattaque():
	if die:return
	if curplayer==null:return
	curplayer.hit(degats_grosse_attaque)
	$GrosCooldown.start()
func sth_exit(sth:Node2D):
	if die:return
	if "isPlayer" in sth and sth.isPlayer:
		curplayer = null
		$PetitCooldown.stop()
		$GrosCooldown.stop()

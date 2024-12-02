@tool
extends Area2D
var x= 29.5
@export var degats_petite_attaque:float=1
@export var degats_grosse_attaque:float=10
@export var cooldown_petite_attaque:float=2
@export var cooldown_grosse_attaque:float=10
@export var speed:float=100.0
@export var lives:int = 5:
	set(x):
		lives=x
		maxlives=lives
		updateLabel()
@export var enemy_name:String="Pieuvre":
	set(x):
		enemy_name=x
		updateLabel()
@export var dialogic_var_name:String="PieuvreState"
@export var spawnpointvillage:String="pieuvrevictoire"
@export var sprite_frames:SpriteFrames:
	set(x):
		sprite_frames=x
		updateSpriteFrames()

var die:bool=false
var already_changing:bool=false
var curplayer
var maxlives:int=5

func _enter_tree() -> void:
	updateLabel()
	updateSpriteFrames()

func updateSpriteFrames():
	$AnimatedSprite2D.sprite_frames=sprite_frames
func updateLabel():
	$Control/Control/Label.text=enemy_name+"\n"+str(lives)+"/"+str(maxlives)+" Vies"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Engine.is_editor_hint():return
	maxlives=lives
	if int(Dialogic.VAR.get_variable(dialogic_var_name))==1 or int(Dialogic.Var.get_variables(dialogic_var_name)==-1):
		die=true
		already_changing=true
		get_tree().current_scene.getPlayer().show_proposition(
			"Vous ne pouvez pas vous battre contre le monstre pour le moment, allez voir le maire pour finir la mission avant de battre le monstre.",
			fight_unavailable,"Retourner au village",null,true)
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
	if Engine.is_editor_hint():return
	updateLabel()
	if die:return
	var dir = global_position.direction_to(get_tree().current_scene.get_node("Player").global_position)
	var v = dir*speed*delta
	global_position+=v

func animation_finished():
	if Engine.is_editor_hint():return
	if die and !already_changing:
		get_tree().current_scene.getPlayer().show_proposition(
			"Vous avez vaincu le monstre! Félicitation, retournez au village voir le maire pour recevoir votre récompense!",
			change_scene_to_wow,"Retourner au village",null,true)
func fight_unavailable():
	if Engine.is_editor_hint():return
	get_tree().current_scene.change_map("res://player_city_map.tscn",spawnpointvillage)
	queue_free()
func change_scene_to_wow():
	if Engine.is_editor_hint():return
	Dialogic.VAR.set_variable(dialogic_var_name,int(Dialogic.VAR.get_variable(dialogic_var_name))+1)
	get_tree().current_scene.change_map("res://player_city_map.tscn",spawnpointvillage)
	queue_free()
func hit(amount:int=1):
	if Engine.is_editor_hint():return
	lives-=amount
	if lives <=0:
		die=true
		$AnimatedSprite2D.play("die")

func sth_enter(sth:Node2D):
	if Engine.is_editor_hint():return
	if die:return
	if "isPlayer" in sth and sth.isPlayer:
		curplayer = sth
		petiteattaque()
		$GrosCooldown.start()
func petiteattaque():
	if Engine.is_editor_hint():return
	if die:return
	if curplayer==null:return
	curplayer.hit(degats_petite_attaque)
	$PetitCooldown.start()
func grosseattaque():
	if Engine.is_editor_hint():return
	if die:return
	if curplayer==null:return
	curplayer.hit(degats_grosse_attaque)
	$GrosCooldown.start()
func sth_exit(sth:Node2D):
	if Engine.is_editor_hint():return
	if die:return
	if "isPlayer" in sth and sth.isPlayer:
		curplayer = null
		$PetitCooldown.stop()
		$GrosCooldown.stop()

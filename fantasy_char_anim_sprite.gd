@tool
extends AnimatedSprite2D

enum SpecialType {
	CHARACTER,
	OTHER
}
@export var specialTypeVal:SpecialType=SpecialType.CHARACTER:
	set(x):
		specialTypeVal=x
		updateSkin()
@export_group("Character")
@export_range(2,5) var chara_no1:int=2:
	set(x):
		chara_no1=x
		updateSkin()
@export_range(1,8) var chara_no2:int=1:
	set(x):
		chara_no2=x
		updateSkin()
@export_group("Other")
## relative to res://Assets/GameDevMarketBundle/over-80-rpg-characters-w-animations/timefantasy_characters/frames/ set {specialTypeVal} to Other to enable (or to reload)
@export var skin_path:String

var file_to_frames:Dictionary={
	"down_stand":{
		"frame":"down",
		"default":true
	},
	"down_walk":{
		"frame":"down_walk",
		"amount":2,
	},
	"laugh":{
		"frame":"laugh",
		"amount":3,
	},
	"left_stand":{
		"frame":"left"
	},
	"left_walk":{
		"frame":"left_walk",
		"amount":2,
	},
	"right_stand":{
		"frame":"right"
	},
	"right_walk":{
		"frame":"right_walk",
		"amount":2,
	},
	"up_stand":{
		"frame":"up"
	},
	"up_walk":{
		"frame":"up_walk",
		"amount":2,
	},
	"shake":{
		"frame":"no",
		"amount":3,
	},
	"nod":{
		"frame":"yes",
		"amount":3,
	},
	"pose":{
		"frame":"pose",
		"amount":3,
	},
	"surprise":{
		"frame":"surprise",
	},
}

func _enter_tree() -> void:
	updateSkin()

func updateSkin():
	#print("mofu")
	match(specialTypeVal):
		SpecialType.CHARACTER:
			#print("oh cool");
			updateSkinF("chara/chara"+str(chara_no1)+"_"+str(chara_no2),true)
			return;
		SpecialType.OTHER:
			#print("oh cool 2")
			updateSkinF(skin_path)
			return;
		_:
			print("error")
			push_error("Error in updateSkin")
			return;
func updateSkinF(path:String, _character_mode:bool=false):
	var fpath = "res://Assets/GameDevMarketBundle/over-80-rpg-characters-w-animations/timefantasy_characters/frames/"+path
	if !ResourceLoader.exists(fpath+"/down_stand.png"):
		print("oh non")
		return
	for i in file_to_frames.keys():
		var f = file_to_frames[i]
		if "amount" in f:
			for j in range(f.amount):
				if ResourceLoader.exists(fpath+"/"+i+str(j+1)+".png"):
					if sprite_frames.get_frame_count(f.frame)<j+1:
						#print("add "+f.frame+str(j))
						sprite_frames.add_frame(f.frame,load(fpath+"/"+i+str(j+1)+".png"))
					else:
						#print("set "+f.frame+str(j))
						sprite_frames.set_frame(f.frame,j,load(fpath+"/"+i+str(j+1)+".png"))
		else:
			if sprite_frames.get_frame_count(f.frame)<1:
				#print("add"+f.frame)
				sprite_frames.add_frame(f.frame,load(fpath+"/"+i+".png"))
			else:
				#print("set "+f.frame)
				sprite_frames.set_frame(f.frame,0,load(fpath+"/"+i+".png"))
			if "default" in f and f.default:
				if sprite_frames.get_frame_count("default")<1:
					#print("add"+"default")
					sprite_frames.add_frame("default",load(fpath+"/"+i+".png"))
				else:
					#print("set "+"default")
					sprite_frames.set_frame("default",0,load(fpath+"/"+i+".png"))
	animation = "default"
	frame = 1
	

func playAnimation(anim:String,custom_speed:float=1.0,from_end:bool=false):
	$AnimationPlayer.play("RESET")
	rotation_degrees=0
	#print(anim);
	if(sprite_frames.has_animation(anim)):
		play(anim,custom_speed,from_end)
		return
	if anim=="die" or anim=="hit":
		play("surprise")
		$AnimationPlayer.play(anim)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

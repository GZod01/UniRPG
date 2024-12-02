@tool
extends "res://addons/dialogic/Modules/LayeredPortrait/layered_portrait.gd"

func super_ready() -> void:
	print("hello")
	print_debug("hello")
	push_warning("hello")
	#var sSelectedSkin:String="23"
	#if !Engine.is_editor_hint():
		#sSelectedSkin=Globals.storySave.selectedSkin
	#print(Globals)
	#$Layer1.texture=$Layer1.texture.ressource_path.replace("chara2_1","chara"+sSelectedSkin[0]+"_"+sSelectedSkin[1])

func _init() -> void:
	super_ready()

func _enter_tree() -> void:
	super_ready()

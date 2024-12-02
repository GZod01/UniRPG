extends Node

var res_preloaded: = {
	
}
var empty_hand={
	"name":"Main vide",
	"texture":"res://Assets/items/empty_hand.png"
}
var items={
	"resurrectPotion":{
		"name":"Potion de Résurrection",
		"stackable":16,
		"texture":"res://Assets/kenney_tiny-dungeon/Tiles/tile_0114.png",
		"consumable":true,
		"description":"Peut réssuciter votre personnage s'il est mort",
		"consum_callback":Callable(func(player:CharacterBody2D):player.lives=10;player.die=false),
		
	},
	"grandMotherBook":{
		"name":"Livre de la grand mère",
		"stackable":1,
		"texture":"res://Assets/items/grandMotherBook.svg",
		"consumable":false,
		"description":"Un livre de la grand mère qui parle de la vie et de la mort",
	},
	"grandFatherSword":{
		"name":"Épée du grand père",
		"stackable":1,
		"consumable":false,
		"texture":"res://Assets/kenney_tiny-dungeon/Tiles/tile_0103.png",
		"description":"Une épée qui appartenait à votre grand père",
		"usable":true,
		"something_enter_callback":Callable(
			func(player:CharacterBody2D,other:Node2D):
				print("slashing ",other, "from ",player)
				if other.has_method("hit") and other!=player:
					other.hit(2)
					return true
				return false
				),
	}
}
var playerInventory = {
	"maxBagSlots":16,
	"bagSlots":[
		{
			"item":"grandMotherBook",
			"quantity":1
		},
		{
			"item":"resurrectPotion",
			"quantity":3
		},
		{
			"item":"grandFatherSword",
			"quantity":1
		}
	],
	"currentEquipped":-1,# -1 for hand slot
}
const DEFAULT_SKIN:int=23
var storySave = {
	"inv":{},
	"storyVariables":{ #Dialogic Variables
	},
	"actionKeys":{},
	"selectedSkin":DEFAULT_SKIN
}

var currentPlayer:CharacterBody2D=CharacterBody2D.new()



var actionsKeysDescriptions = {
	"up":"Se déplacer vers le haut",
	"down": "Se déplacer vers le bas",
	"left":"Se déplacer vers la gauche",
	"right":"Se déplacer vers la droite",
	"sprint":"Courrir",
	"debugOpen":"Ouvrir le menu de debug",
	"use_item":"Utiliser l'outil actuel",
	"inventory":"Ouvrir l'inventaire",
	"helpMenu":"Ouvrir/fermer le panneau aide",
	"dialog_enter":"Discuter avec le personnage",
	"pause":"Activer/Desactiver la pause"
}
var existingActions=["up","down","left","right","sprint","debugOpen","use_item","inventory","helpMenu","dialog_enter","pause"];
var actionsToShowInHelp= ["up","down","left","right","sprint","use_item","inventory","dialog_enter","helpMenu","pause"]
var actionKeys={}

func _ready():
	self.process_mode=Node.PROCESS_MODE_ALWAYS
	var pause_menu = load("res://pause_menu.tscn").instantiate()
	pause_menu.name="PauseMenu"
	self.add_child(pause_menu,true)
	await Dialogic.ready
	load_game()

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		#print("hello")
		#print($PauseMenu)
		#print($PauseMenu.visible)
		$PauseMenu.togglePause()

func updateKeySettings():
	var nactionKeys={}
	#print("entering")
	for i in existingActions:
		#print(i)
		print(InputMap.has_action(StringName(i)))
		if !InputMap.has_action(StringName(i)):
			#print(InputMap.get_actions())
			continue
		#print("\n\n---\n\n")
		nactionKeys[i]=[]
		#print(nactionKeys)
		for k in InputMap.action_get_events(i):
			nactionKeys[i].append(k.as_text())
	#print(nactionKeys)
	actionKeys = nactionKeys.duplicate(true)
	return
func getKeySettings():
	return actionKeys
func register_current_player(caller:CharacterBody2D):
	currentPlayer=caller
func getPlayer():
	return currentPlayer if ("isPlayer" in currentPlayer and currentPlayer.isPlayer) else null

func load_game():
	if !FileAccess.file_exists("user://unirpg.sav"):return
	var fcontnent = FileAccess.get_file_as_string("user://unirpg.sav")
	var fsav = JSON.parse_string(fcontnent)
	for k in storySave.keys():
		if !(k in fsav):
			fsav[k]=storySave[k]
	storySave=fsav
	for k in playerInventory.keys():
		if !(k in storySave["inv"]):
			storySave["inv"][k]=playerInventory[k]
	playerInventory=storySave["inv"]
	for k in storySave.storyVariables.keys():
		Dialogic.VAR.set_variable(k,storySave.storyVariables[k])
	var sSelectedSkin = str(storySave["selectedSkin"])
	if int(sSelectedSkin[0])<2 or int(sSelectedSkin[0])>5 or int(sSelectedSkin[1])<1 or int(sSelectedSkin[1])>8:
		sSelectedSkin=str(DEFAULT_SKIN)
	storySave.selectedSkin=int(sSelectedSkin)
	#print("loaded storysave: ",storySave)

func save_game():
	storySave["inv"]=playerInventory
	for k in Dialogic.VAR.variables():
		storySave.storyVariables[k]=Dialogic.VAR.get_variable(k)
	var tosave = JSON.stringify(storySave)
	#print(tosave)
	var f =FileAccess.open("user://unirpg.sav",FileAccess.WRITE)
	f.store_string(tosave)
func preload_res(filename:String,forcereload:bool=false)->Resource:
	#print("start laod")
	var havetoreload:bool=false
	if forcereload:
		havetoreload=true
	if !filename in res_preloaded:
		havetoreload=true
	if havetoreload:
		var loaded = load(filename)#await load(filename)
		#print("passed here")
		res_preloaded[filename] = loaded
	#print("hide load")
	return res_preloaded[filename]
		

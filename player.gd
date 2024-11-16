extends CharacterBody2D
const isPlayer = true
const SPEED = 128  # 4 meters per second
const SPRINT_SPEED = 256  # 8 meters per second
const JUMP_VELOCITY = -400.0
var change_scene = null
var change_scene_fromWhere = null
var proposition_callback: Callable = Callable(func(): print("used bad one"))
var proposition_refuse_callback: Callable = Callable(func(): print("refuse_call"))
var lives: int = 10
var max_lives_player: int = 10
var max_lives = max_lives_player
var die: bool = false

func _ready() -> void:
	Globals.updateKeySettings()
	Globals.register_current_player(self)
	$CanvasLayer/UI/InUI/LiveLabel.text = ("%d/%d vies" % [lives, max_lives])
	print(get_tree().current_scene.name)
	$Camera2D.zoom = Vector2.ONE * get_tree().current_scene.map_player_zoom
	$AnimatedSprite2D.play("default")
	inventory_update()

func inventory_update():
	for i in range(Globals.playerInventory.maxBagSlots):
		print(i)
		var item = Globals.playerInventory.bagSlots[i] if len(Globals.playerInventory.bagSlots)>=i+1 else null
		if item:
			var icon = Globals.preload_res(Globals.items[item["item"]]["texture"])#await Globals.preload_res(Globals.items[item["item"]]["texture"])
			if $CanvasLayer/UI/Inventory/VBoxContainer/InventorySlots.item_count <i+1:$CanvasLayer/UI/Inventory/VBoxContainer/InventorySlots.add_icon_item(icon)
			else:$CanvasLayer/UI/Inventory/VBoxContainer/InventorySlots.set_item_icon(i,icon)
			#push_warning("hello + "+str(i))
			$CanvasLayer/UI/Inventory/VBoxContainer/InventorySlots.set_item_selectable(i,true)
			$CanvasLayer/UI/Inventory/VBoxContainer/InventorySlots.set_item_text(i,str(item["quantity"]))
			$CanvasLayer/UI/Inventory/VBoxContainer/InventorySlots.set_item_tooltip(i,Globals.items[item["item"]]["name"]+"\n"+Globals.items[item["item"]]["description"])
		else:
			var icon = Globals.preload_res("res://air.svg")#await Globals.preload_res("res://air.svg")
			if $CanvasLayer/UI/Inventory/VBoxContainer/InventorySlots.item_count <i+1:$CanvasLayer/UI/Inventory/VBoxContainer/InventorySlots.add_icon_item(icon,false)
			else:$CanvasLayer/UI/Inventory/VBoxContainer/InventorySlots.set_item_icon(i,icon)
			$CanvasLayer/UI/Inventory/VBoxContainer/InventorySlots.set_item_selectable(i,false)
			$CanvasLayer/UI/Inventory/VBoxContainer/InventorySlots.set_item_text(i,"")
			$CanvasLayer/UI/Inventory/VBoxContainer/InventorySlots.set_item_tooltip(i,"")
func inventory_contain(id: String):
	return (id in Globals.playerInventory.bagSlots) or (id in Globals.playerInventory.equipSlots)
func inventory_amount(id: String):
	var ret=0
	for ki in range(0,(len(Globals.playerInventory.bagSlots)-1)+(len(Globals.playerInventory.equipSlots)-1)):
		print(ki)
		var keytoedit = "bagSlots" if ki<len(Globals.playerInventory.bagSlots)else "equipSlots"
		var i =Globals.playerInventory[keytoedit][ki]
		if i["item"]==id:
			ret+=i["quantity"]
	return ret

func rand_choice(arr:Array,shufflemode:bool=true):
	if !shufflemode:
		var rand =RandomNumberGenerator.new()
		rand.randomize()
		return arr[rand.randi_range(0,arr.size()-1)]
	randomize()
	var arr2 = arr.duplicate(true)
	arr2.shuffle()
	return arr2[0]
func get_full_inv():
	var toret=[]
	toret = Globals.playerInventory.bagSlots.duplicate(true)
	toret.append_array(Globals.playerInventory.equipSlots.duplicate(true))
	return toret
func inventory_add_item(id:String, ammount:int):
	if ammount<1:return
	print(Globals.playerInventory)
	print("added item %s with quantity %d"%[id,ammount])
	for ki in range(0,(len(Globals.playerInventory.bagSlots)-1)+(len(Globals.playerInventory.equipSlots)-1)):
		print(ki)
		var keytoedit = "bagSlots" if ki<len(Globals.playerInventory.bagSlots)else "equipSlots"
		var i =Globals.playerInventory[keytoedit][ki]
		if i["item"]==id and i["quantity"]<Globals.items[i["item"]]["stackable"]:
			var available_ammount = Globals.items[i["item"]]["stackable"]-i["quantity"]
			var ammtoput = ammount if ammount <= available_ammount else available_ammount
			Globals.playerInventory[keytoedit][ki]["quantity"]+=ammtoput
			if ammount > available_ammount:
				inventory_add_item(id,ammount-ammtoput)
			inventory_update()
			return
	print("one")
	if !((len(Globals.playerInventory.bagSlots)<=Globals.playerInventory["maxBagSlots"]) and (len(Globals.playerInventory.equipSlots)<Globals.playerInventory.maxEquipSlots)):
		show_proposition("Vous devez apprendre une compétence pour augmenter la taille de votre inventaire",Callable(func():$CanvasLayer/UI/CompetenceMenu.show()),"Je vais améliorer ma compétence 'Stockage Amélioré'")
	print("three")
	Globals.playerInventory.bagSlots.append({"item":id,"quantity":1})
	inventory_add_item(id,ammount-1)
	inventory_update()
	return
func inventory_rem_item(id:String,ammount:int):
	print("will rem item "+id, ammount)
	if ammount<1:return
	print(ammount)
	for ki in range(0,(len(Globals.playerInventory.bagSlots)-1)+(len(Globals.playerInventory.equipSlots)-1)):
		print(ki)
		var keytoedit = "bagSlots" if ki<len(Globals.playerInventory.bagSlots)else "equipSlots"
		var i =Globals.playerInventory[keytoedit][ki]
		var havetobreak:bool=false
		if i["item"]==id:
			print("removed")
			Globals.playerInventory[keytoedit][ki]["quantity"]-=ammount
			havetobreak=true
			spawnTextParticle("-"+str(ammount)+" "+Globals.items[id]["name"],Color.PURPLE)
		if i["quantity"]<=0:
			print("quantity 0 rem")
			Globals.playerInventory[keytoedit].pop_at(ki)
			if havetobreak:return
	return
func inventory_current_equiped():
	var currentEquiped = Globals.playerInventory.currentEquipped
	if currentEquiped==-1 or currentEquiped>=len(Globals.playerInventory.equipSlots):
		return null
	return Globals.playerInventory.equipSlots[currentEquiped]
func slash_with_item(item:Dictionary):
	if item:
		if Globals.items[item["item"]]["usable"]:
			$ItemSlashArea2D.slash(item["item"])
			
func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("inventory"):
		$CanvasLayer/UI/Inventory.visible=!$CanvasLayer/UI/Inventory.visible
		inventory_update()
	if die: return
	if Input.is_action_just_pressed("use_item"):
		var item = inventory_current_equiped()
		if item:
			if Globals.items[item["item"]]["usable"]:
				slash_with_item(item)
	var animation = $AnimatedSprite2D.animation if $AnimatedSprite2D.animation else "default";
	var running: bool = Input.is_action_pressed("sprint")
	var direction := Input.get_vector("left", "right", "up", "down")
	if direction:
		velocity = direction * (SPEED if !running else SPRINT_SPEED)
		animation = ("walk" if !running else "run")
		$AnimatedSprite2D.flip_h = direction.x < 0
	else:
		if $AnimatedSprite2D.animation in ["run", "default", "walk"]:
			animation = ("default")
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
	if get_tree().current_scene.map_name == "islands_map":
		$Boat.show()
		if direction:
			animation = "walk"
			if direction.x < 0:
				$Boat.position.x = -1
				$Boat.scale = Vector2(-1, 1)
			else:
				$Boat.position.x = 1
				$Boat.scale = Vector2(1, 1)
	else:
		$Boat.hide()
	if animation != $AnimatedSprite2D.animation:
		$AnimatedSprite2D.play(animation)
	move_and_slide()

func show_change_map_proposition(message, scene, fromWhere = ""):
	if die: return
	change_scene = scene
	change_scene_fromWhere = fromWhere
	$CanvasLayer/UI/ChangeMap/VBoxContainer/Label.text = message
	$CanvasLayer/UI/ChangeMap.show()
func hide_change_map_proposition():
	change_scene = null
	$CanvasLayer/UI/ChangeMap.hide()

func show_proposition(message: String, callback: Callable, custom_accept = null, custom_refuse = null, refuse_disabled: bool = false, refuse_callback: Callable = Callable(func(): print("refused call"))):
	$CanvasLayer/UI/Proposition/VBoxContainer/Label.text = message
	$CanvasLayer/UI/Proposition/VBoxContainer/Accept.text = custom_accept if custom_accept else "Accepter"
	$CanvasLayer/UI/Proposition/VBoxContainer/Refuse.text = custom_refuse if custom_refuse else "Refuser"
	$CanvasLayer/UI/Proposition/VBoxContainer/Refuse.disabled = refuse_disabled
	$CanvasLayer/UI/Proposition.show()
	print("callback", callback)
	self.proposition_callback = Callable(callback)
	self.proposition_refuse_callback = Callable(refuse_callback)
func hide_proposition():
	$CanvasLayer/UI/Proposition.hide()

func _on_accept_change_button_pressed() -> void:
	get_tree().current_scene.change_map(change_scene, change_scene_fromWhere)
	hide_change_map_proposition()


func _on_accept_pressed() -> void:
	hide_proposition()
	print(proposition_callback)
	if proposition_callback is Callable and proposition_callback!=null:
		print("hello")
		proposition_callback.call()
	proposition_callback = Callable(func(): pass )
	proposition_refuse_callback = Callable(func(): pass )


func _on_refuse_pressed() -> void:
	hide_proposition()
	if self.proposition_refuse_callback is Callable:
		self.proposition_refuse_callback.call()
		$CanvasLayer/UI/Proposition.hide()
	proposition_callback = Callable(func(): pass )
	proposition_refuse_callback = Callable(func(): pass )

func refuse_proposition():
	self._on_refuse_pressed()

func hit(amount: int):
	if die: return
	lives -= amount
	if lives <= 0:
		$AnimatedSprite2D.play("die")
		die = true
		show_proposition(
			"Vous êtes mort, souhaitez vous abandonner le combat et ressusciter chez vous ou boire une potion de résurrection %s" %
				[("(%d dans votre inventaire)"%inventory_amount("resurrectPotion"))],
			Callable(
				func(): get_tree().change_scene_to_file("res://world.tscn")
			),
			"Réssuciter à la maison","Utiliser la potion",inventory_contain("resurrectPotion"),Callable(func():
				die=false; hit(-max_lives); inventory_rem_item("resurrectPotion",1); $AnimatedSprite2D.play("default"))
		)
	$CanvasLayer/UI/InUI/LiveLabel.text = ("%d/%d vies" % [lives, max_lives])
	$AnimatedSprite2D.play("hit")
	print("hitted with " + str(amount))
	spawnTextParticle(str(abs(amount)),Color.RED if amount>0 else Color.GREEN)
func spawnTextParticle(message:String,color:Color):
	var particleGeneratorHit = load("res://partcle_text_emitter.tscn").instantiate()
	particleGeneratorHit.emit_at_start = false
	$CanvasLayer/UI/LiveHitShow.add_child(particleGeneratorHit)
	particleGeneratorHit.labelsettings = LabelSettings.new()
	particleGeneratorHit.labelsettings.font_color = color
	particleGeneratorHit.text = message
	particleGeneratorHit.emitParticle()
	return true


func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation=="hit":$AnimatedSprite2D.play("default")

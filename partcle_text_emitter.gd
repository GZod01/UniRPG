@tool
extends Node2D
@export var emit_at_start:bool=true
@export var emitting:bool=false:
	set(value):
		emitting=value
		if value==true:emitParticle()
@export_group("Particle Text")
@export var labelsettings:LabelSettings:
	set(value):
		labelsettings=value
		updateParticleText()
@export var text: String="Hello" :
	set(value):
		text=value
		updateParticleText()

@export_group("Emitter")
@export var one_shot:bool=true:
	set(value):
		one_shot=value
		updateParticleEmitter()
@export var process_material:ParticleProcessMaterial=preload("res://partcle_text_emitter.tres"):
	set(value):
		process_material=value
		updateParticleEmitter()

func updateParticleText():
	if !Engine.is_editor_hint() and !is_node_ready():return
	#print("hellosuperuspeuarpuaer")
	print(self)
	print(get_children())
	for n in get_children():
		print(n.name)
	$ParticleText.labelsettings=labelsettings
	$ParticleText.text=text

func updateParticleEmitter():
	if !Engine.is_editor_hint() and !is_node_ready():return
	$GPUParticles2D.process_material=process_material
	$GPUParticles2D.one_shot=one_shot

func emitParticle()->void:
	print("helloworld hitted started")
	#$GPUParticles2D.emitting=true
	#(func():
		#await get_tree().create_timer(0.2).timeout
		#$GPUParticles2D.emitting=false
		#emitting=false;
	#).call_deferred()
	$GPUParticles2D.restart()
	emitting=false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("hello")
	$GPUParticles2D.texture=$ParticleText.get_viewport().get_texture()
	#$GPUParticles2D.texture.viewport_path="ParticleText"
	print("hello")
	updateParticleEmitter()
	updateParticleText()
	if emit_at_start and !Engine.is_editor_hint():
		emitParticle()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

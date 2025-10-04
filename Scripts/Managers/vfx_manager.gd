class_name VFXManager extends Node

@export var vfx_map: Dictionary[Global.EVFXType, ParticleProcessMaterial]

var vfx_emitter_scene = preload("res://Scenes/Managers/vfx_emitter.tscn")
var vfx_pool: Array[VFXEmitter] = []

const pool_size = 10

func _ready() -> void:
	Global.vfx_manager = self

	for n in range(pool_size):
		_create_vfx()

func _get_free_vfx_from_pool() -> VFXEmitter:
	for n in range(vfx_pool.size()):
		if !vfx_pool[n].is_active():
			vfx_pool[n].activate()
			return vfx_pool[n]
	
	# No free vfx, make one
	var instance = _create_vfx()
	instance.activate()
	return instance

func _create_vfx() -> VFXEmitter:
	var instance: VFXEmitter = vfx_emitter_scene.instantiate()
	instance.name = "VFXEmitter" + str(vfx_pool.size())
	instance.deactivate()
	add_child(instance)
	vfx_pool.append(instance)
	return instance

func play_vfx(vfx_type: Global.EVFXType, pos: Vector2 = Vector2.ZERO) -> void:
	if vfx_map.get(vfx_type) == null:
		push_error("Couldn't play " + Global.EVFXType.keys()[vfx_type] + " because it doesn't exist in the vfx_map!")
		return
	#print("Playing: " + Global.EVFXType.keys()[vfx_type])
	var vfx_emitter = _get_free_vfx_from_pool()
	vfx_emitter.play_vfx(vfx_map[vfx_type], vfx_type, pos)

func stop_audio(vfx_type: Global.EVFXType) -> bool:
	#print("Stopping: " + Global.EVFXType.keys()[vfx_type])
	for vfx in vfx_pool:
		if vfx.get_vfx_type() == vfx_type:
			vfx.deactivate()
			return true
	return false

func stop_all_vfx() -> void:
	#print("Stopping All Audio!")
	for vfx in vfx_pool:
		if vfx.is_active():
			vfx.deactivate()

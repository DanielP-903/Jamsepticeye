class_name VFXEmitter extends GPUParticles2D

var active = false
var vfx_type: Global.EVFXType

func _ready() -> void:
	finished.connect(_on_vfx_finished.bind(self))
	deactivate()

func activate() -> void:
	active = true
	#print("Activated: " + name)

func deactivate() -> void:
	if emitting:
		emitting = false
	position = Vector2.ZERO
	process_material = null
	active = false
	#print("Deactivated: " + name)

func is_active() -> bool:
	return active

func play_vfx(new_vfx_material: ParticleProcessMaterial, type: Global.EVFXType, emitter_pos: Vector2) -> void:
	activate()
	position = emitter_pos
	process_material = new_vfx_material
	vfx_type = type
	emitting = true

func _on_vfx_finished(finished_vfx: GPUParticles2D):
	deactivate()

func get_vfx_type() -> Global.EVFXType:
	return vfx_type

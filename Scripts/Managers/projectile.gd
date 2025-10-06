class_name Projectile extends Area2D

var active = false

@export var projectile_speed: float = 150.0
@export var projectile_lifetime: float = 15.0
@export var sprite: Sprite2D

var life_timer: float = 0.0
var direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	deactivate()

func activate() -> void:
	set_physics_process(true)
	set_process(true)
	set_deferred("monitoring", true)	

	life_timer = 0.0
	
	self.show()
	
	active = true
	#print("Activated: " + name)

func deactivate() -> void:
	set_physics_process(false)
	set_process(false)
	set_deferred("monitoring", false)	
	
	self.hide()
	
	position = Vector2.ZERO
	active = false
	#print("Deactivated: " + name)

func is_active() -> bool:
	return active

func _physics_process(_delta) -> void:
	position += direction * projectile_speed * _delta

func _process(_delta) -> void:
	life_timer += _delta
	if(life_timer >= projectile_lifetime):
		deactivate()
		print("timer death")

func setup_projectile(pos: Vector2, dir: Vector2, character_owned_by: CharacterCommon) -> void:
	position = pos
	direction = dir.normalized()
	rotation = dir.angle() # Rotate the scene to the direction of fire
	
	if !character_owned_by:
		return
	
	# layer 1 = player, layer 2 = enemy
	set_collision_mask_value(1, !character_owned_by.is_possessed)
	set_collision_mask_value(2, character_owned_by.is_possessed)
	
	sprite.modulate = Global.friendly_colour if character_owned_by.is_possessed else Global.enemy_colour

func _on_body_entered(body: Node2D) -> void:
	deactivate()
	var character = body as Character
	character.take_damage(randi_range(25,35))
	Global.vfx_manager.play_vfx(Global.EVFXType.hurt, character.position)
	Global.audio_manager.play_audio(Global.EAudioType.enemy_hit, 0.5)

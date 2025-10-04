class_name Projectile extends Node2D
var active = false

@export var projectile_speed: float = 150.0
@export var projectile_lifetime: float = 15.0
@export var collider: Area2D

var life_timer: float = 0.0
var direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	deactivate()

func activate() -> void:
	set_physics_process(true)
	set_process(true)
	collider.monitoring = true
	collider.monitorable = true
	
	self.show()
	
	active = true
	#print("Activated: " + name)

func deactivate() -> void:
	set_physics_process(false)
	set_process(false)
	collider.monitoring = false
	collider.monitorable = false
	
	self.hide()
	
	position = Vector2.ZERO
	active = false
	#print("Deactivated: " + name)

func is_active() -> bool:
	return active

func _physics_process(_delta) -> void:
	if(is_active()):
		position += direction * projectile_speed * _delta

		if(collider.has_overlapping_areas() || collider.has_overlapping_bodies()):
			queue_free()
			print("collision death")

func _process(_delta) -> void:
	if(is_active()):
		life_timer += _delta
		if(life_timer >= projectile_lifetime):
			queue_free()
			print("timer death")

func setup_projectile(_position: Vector2, _direction: Vector2) -> void:
	position = _position
	direction = _direction.normalized()
	rotation = _direction.angle()	#	Rotate the scene to the direction of fire

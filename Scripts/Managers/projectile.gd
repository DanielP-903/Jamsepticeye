class_name Projectile extends Node2D
var active = false

func _ready() -> void:
	deactivate()

func activate() -> void:
	# TODO: activate collisions
	
	active = true
	#print("Activated: " + name)

func deactivate() -> void:
	# TODO: disable collisions
	
	position = Vector2.ZERO
	active = false
	#print("Deactivated: " + name)

func is_active() -> bool:
	return active

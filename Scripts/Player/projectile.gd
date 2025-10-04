extends Node2D

@export var projectile_speed: float = 150.0
@export var projectile_lifetime: float = 15.0
@export var collider: Area2D

var life_timer: float = 0.0
var direction: Vector2 = Vector2.ZERO

#func _init():
	#	TODO: Rotate the projectile to the direction it has set

func _physics_process(_delta) -> void:
	position += direction*projectile_speed*_delta

	if(collider.has_overlapping_areas() || collider.has_overlapping_bodies()):
		queue_free()

func _process(_delta) -> void:
	life_timer += _delta
	if(life_timer >= projectile_lifetime):
		queue_free()

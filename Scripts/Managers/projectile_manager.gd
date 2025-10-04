class_name ProjectileManager extends Node

var projectile_scene = preload("res://Scenes/Managers/projectile.tscn")
var projectile_pool: Array[Projectile] = []

const pool_size = 10

func _ready() -> void:
	Global.projectile_manager = self
	
	for n in range(pool_size):
		_create_projectile()

func _get_free_projectile_from_pool() -> Projectile:
	for n in range(projectile_pool.size()):
		if !projectile_pool[n].is_active():
			projectile_pool[n].activate()
			return projectile_pool[n]
	
	# No free vfx, make one
	var instance = _create_projectile()
	instance.activate()
	return instance

func _create_projectile() -> Projectile:
	var instance: Projectile = projectile_scene.instantiate()
	instance.name = "Projectile" + str(projectile_pool.size())
	instance.deactivate()
	add_child(instance)
	projectile_pool.append(instance)
	return instance

func spawn_projectile(position: Vector2, direction: Vector2, projectile_owner: CharacterCommon) -> Projectile:
	var projectile = _get_free_projectile_from_pool()
	projectile.position = position
	# TODO
	#projectile.direction = direction
	#projectile.owning_character = projectile_owner # Should be used for collision (aka don't collide with the owner)
	return projectile

func kill_all_projectiles() -> void:
	#print("Killing ALL Projectiles!")
	for projectile in projectile_pool:
		if projectile.is_active():
			projectile.deactivate()

class_name EnemyManager extends Node

var enemy_scene = preload("res://Scenes/Characters/enemy-cowboy.tscn")
var enemy_pool: Array[Node2D] = []

const pool_size = 10

func _ready() -> void:
	Global.enemy_manager = self
	
	for n in range(pool_size):
		_create_enemy()

func _get_free_enemy_from_pool() -> Node2D:
	for n in range(enemy_pool.size()):
		if !enemy_pool[n].is_active():
			enemy_pool[n].activate()
			return enemy_pool[n]
	
	# No free vfx, make one
	var instance = _create_enemy()
	# TODO: instance.activate()
	return instance

func _create_enemy() -> Node2D:
	var instance: Node2D = enemy_scene.instantiate()
	instance.name = "Enemy" + str(enemy_pool.size())
	# TODO: instance.deactivate()
	add_child(instance)
	enemy_pool.append(instance)
	return instance

func spawn_enemy(position: Vector2) -> Node2D:
	var enemy = _get_free_enemy_from_pool()
	enemy.position = position
	return enemy

func kill_all_enemies() -> void:
	#print("Killing ALL Enemies!")
	for enemy in enemy_pool:
		if enemy.is_active():
			# TODO:
			#enemy.deactivate()
			pass

class_name EnemyManager extends Node

var enemy_scene = preload("res://Scenes/Characters/character.tscn")
var enemy_pool: Array[Character] = []

const pool_size = 3

const max_enemies_at_once = 8
const start_enemy_count = 3
const time_between_spawn = 1000
const time_before_start = 2000

var wave_number
var enemies_defeated

var enemy_count
var enemies_remaining
var last_enemy_spawn_time

var counting_down: bool

var allow_spawning: bool

func _ready() -> void:
	Global.enemy_manager = self
	
	reset()
	
	for n in range(pool_size):
		_create_enemy()

func reset() -> void:
	wave_number = 0
	enemies_defeated = 0
	
	counting_down = false
	allow_spawning = false
	
	enemy_count = 0
	enemies_remaining = 0
	last_enemy_spawn_time = Time.get_ticks_msec()

func _process(delta: float) -> void:
	if allow_spawning:
		if enemy_count < max_enemies_at_once and enemies_remaining > enemy_count and Time.get_ticks_msec() - last_enemy_spawn_time > time_between_spawn:
			enemy_count += 1
			spawn_enemy(get_random_position_around_screen())
			last_enemy_spawn_time = Time.get_ticks_msec()
			print("Spawning Enemy")
		elif enemies_remaining == 0 and enemy_count == 0:
			begin_next_wave_coundown()
	
	if !counting_down:
		return
	
	if Time.get_ticks_msec() - last_enemy_spawn_time > time_before_start:
		counting_down = false
		#print("STARTED!")
		_start_next_wave()
	#else:
		#var countdown: int = floori((time_before_start - (Time.get_ticks_msec() - last_enemy_spawn_time)) / 1000.0) + 1
		#print(countdown)

func get_random_position_around_screen() -> Vector2:
	var SCREEN_X = 170
	var SCREEN_Y = 100
	
	var rand_x = randf_range(-SCREEN_X, SCREEN_X)
	var rand_y = randf_range(-SCREEN_Y, SCREEN_Y)
	
	var coin_toss = randi_range(0,100)
	
	if coin_toss < 25:
		return Vector2(rand_x, SCREEN_Y)
	if coin_toss < 50:
		return Vector2(rand_x, -SCREEN_Y)
	if coin_toss < 75:
		return Vector2(SCREEN_X, rand_y)
	
	return Vector2(-SCREEN_X, rand_y)

func begin_next_wave_coundown() -> void:
	allow_spawning = false
	counting_down = true
	last_enemy_spawn_time = Time.get_ticks_msec()	

func on_enemy_killed(from_possession: bool):
	print("ENEMY KILLED")
	enemy_count -= 1
	enemies_remaining -= 1
	
	enemies_defeated += 1
	
	if !from_possession:
		Global.audio_manager.play_audio(Global.EAudioType.enemy_death, 1.1)
	else:
		Global.audio_manager.play_audio(Global.EAudioType.enemy_possessed, 0.9)
	var hud = Global.game_state_controller.get_hud()
	if hud:
		hud.set_enemies_left(enemies_remaining)

func _start_next_wave() -> void:
	wave_number += 1
	enemies_remaining = start_enemy_count + (floori(pow(1.8, wave_number / 2.0)) - 1)
	enemies_remaining = clampi(enemies_remaining, 3, 24)
	
	var hud = Global.game_state_controller.get_hud()
	if hud:
		hud.set_enemies_left(enemies_remaining)
		hud.set_wave_number(wave_number)
	
	# Spawn the enemies!
	allow_spawning = true
	last_enemy_spawn_time = -1 # TODO replace with float min or something
	
	print("Wave " + str(wave_number) + " has begun... | Enemies remaining = " + str(enemies_remaining))

func _get_free_enemy_from_pool() -> Character:
	for n in range(enemy_pool.size()):
		if !enemy_pool[n].is_active():
			enemy_pool[n].activate()
			return enemy_pool[n]
	
	# No free vfx, make one
	var instance = _create_enemy()
	instance.activate()
	return instance

func _create_enemy() -> Character:
	var instance: Character = enemy_scene.instantiate()
	instance.name = "Enemy" + str(enemy_pool.size())
	instance.deactivate()
	add_child(instance)
	enemy_pool.append(instance)
	return instance

func spawn_enemy(position: Vector2) -> Character:
	var enemy = _get_free_enemy_from_pool()
	enemy.position = position
	return enemy

func kill_all_enemies() -> void:
	#print("Killing ALL Enemies!")
	for enemy in enemy_pool:
		if enemy.is_active():
			enemy.deactivate()

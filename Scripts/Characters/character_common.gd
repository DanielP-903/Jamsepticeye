extends CharacterBody2D

class_name CharacterCommon

@export var is_starting_player: bool = false

@export var health: float = 100
@export var speed: int = 100
@export var enemy_speed: int = 20
@export var fire_timeout: float = 0.5
@export var sprite : Sprite2D
@export var possession_highlight_sprite: Sprite2D
@export var possession_area: Area2D
var is_possessed: bool = false
var is_highlighted: bool = false
var ignore_physics_tick: bool = false
var fire_timer: float = 0.0

var last_enemy_fire_time: float = 0.0
var current_time_between_fire: float = 5000.0

func _ready() -> void:
	is_highlighted = false
	ignore_physics_tick = false
	fire_timer = 0.0
	last_enemy_fire_time = 0.0
	current_time_between_fire = 5000.0

	if is_starting_player:
		is_possessed = true
		Global.game_state_controller.current_player = self
		(self as Character).activate()
	else:
		is_possessed = false
		(self as Character).deactivate()

func _physics_process(_delta) -> void:
	if(!ignore_physics_tick):
		if(is_possessed):
			get_input()
		else:
			_calculate_velocity()
		move_and_slide()
	else:
		ignore_physics_tick = false

func _calculate_velocity():
	velocity = Vector2.ZERO
	
	if !Global.game_state_controller.is_playing_game():
		return
	
	var player = Global.game_state_controller.get_player()
	if player == null:
		return
	
	velocity = (player.position - position).normalized() * enemy_speed

func _process(_delta) -> void:
	if is_possessed:
		take_damage(0.05)
		check_bounds()
	else:
		_random_fire_projectile()
		if possession_highlight_sprite.self_modulate != Color.TRANSPARENT:
			show_possession_highlight()
	#show_possession_highlight()
	_update_sprites()
	check_health_for_death()
	
	if(fire_timer < fire_timeout):
		fire_timer += _delta

func check_bounds() -> void:
	if position.x > 150.0:
		position.x = 150.0
	if position.x < -150.0:
		position.x = -150.0
	if position.y > 80.0:
		position.y = 80.0
	if position.y < -80.0:
		position.y = -80.0

func _random_fire_projectile() -> void:
	if Time.get_ticks_msec() - last_enemy_fire_time > current_time_between_fire:
		var player = Global.game_state_controller.get_player()
		if player:
			last_enemy_fire_time = Time.get_ticks_msec()
			current_time_between_fire = randi_range(3000, 5000)
			var direction = player.position - position
			Global.projectile_manager.spawn_projectile(position, direction, self)
			Global.audio_manager.play_audio(Global.EAudioType.fire, 0.8)

#	Move the player
func get_input() -> void:
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction*speed
	
	if(Input.is_action_pressed("fire") && fire_timer >= fire_timeout):
		var direction = get_global_mouse_position() - position
		Global.projectile_manager.spawn_projectile(position, direction, self)
		fire_timer = 0.0
		Global.audio_manager.play_audio(Global.EAudioType.fire, 0.9)
		#print("pew")

func get_health() -> float:
	return health

#func show_possession_highlight() -> void:
	#if(!is_possessed):
		#is_highlighted = possession_area.has_overlapping_areas()
#
	#if(is_possessed || !is_highlighted):
		#possession_highlight_sprite.self_modulate = Color.TRANSPARENT
	#if(is_highlighted && !is_possessed):
		#possession_highlight_sprite.self_modulate = Color.WHITE

func take_damage(damageAmount) -> void:
	if(damageAmount > health):
		health = 0
	else:
		health -= damageAmount
	if is_possessed:
		Global.game_state_controller.get_hud().set_health_percent(health)
	else:
		(self as Character).overhead_health.value = health

func possess() -> void:
	is_possessed = true
	ignore_physics_tick = true
	Global.game_state_controller.current_player = self
	Global.game_state_controller.get_hud().set_health_percent(health)
	sprite.modulate = Global.friendly_colour
	(self as Character).overhead_health.hide()
	
	possession_area.set_collision_layer_value(1, is_possessed)
	possession_area.set_collision_layer_value(2, !is_possessed)
	set_collision_layer_value(1, is_possessed)
	set_collision_layer_value(2, !is_possessed)
	
	Global.vfx_manager.play_vfx(Global.EVFXType.possess, position)

func unpossess() -> void:
	is_possessed = false
	if is_starting_player:
		queue_free.call_deferred()
	else:
		(self as Character).deactivate()
	sprite.modulate = Global.enemy_colour
	(self as Character).overhead_health.show()

func show_possession_highlight():
	if health < 50.0:
		possession_highlight_sprite.self_modulate = Color.LIME_GREEN
	else:
		possession_highlight_sprite.self_modulate = Color.DARK_RED

func hide_possession_highlight():
	possession_highlight_sprite.self_modulate = Color.TRANSPARENT

func _update_sprites() -> void:
	if !sprite:
		return
	
	if is_possessed:
		# Flip the sprite depending on the mouse position	
		sprite.flip_h = position > get_global_mouse_position()
	else:
		# Flip enemy sprites based on velocity
		var player = Global.game_state_controller.get_player()
		if player:
			sprite.flip_h = position > player.position

func get_z() -> float:
	return sprite.position.y

func check_health_for_death() -> void:
	if(health <= 0 and !Global.game_state_controller.is_game_over):
		if(!is_possessed):
			(self as Character).deactivate()
			Global.enemy_manager.on_enemy_killed(false)
		else:
			Global.game_state_controller.game_over()

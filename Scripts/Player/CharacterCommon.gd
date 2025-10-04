extends CharacterBody2D

class_name CharacterCommon

@export var health: int = 100
@export var speed: int = 100
@export var fire_timeout: float = 0.5
@export var player_sprite : Sprite2D
@export var crosshair: Sprite2D
@export var possession_highlight_sprite: Sprite2D
@export var possession_area: Area2D
@export var crosshair_area: Area2D
@export var projectile_manager: ProjectileManager
var is_possessed: bool = false
var is_highlighted: bool = false
var ignore_physics_tick: bool = false
var fire_timer: float = 0.0

func _physics_process(_delta) -> void:
	if(!ignore_physics_tick):
		if(is_possessed):
			get_input()
			move_and_slide()
	else:
		ignore_physics_tick = false

func _process(_delta) -> void:
	show_possession_highlight()
	_update_sprites()
	check_health_for_death()
	if(crosshair != null):
		if(!crosshair.visible && is_possessed):
			crosshair.show()
		elif(crosshair.visible && !is_possessed):
			crosshair.hide()
			
	if(fire_timer < fire_timeout):
		fire_timer += _delta

#	Move the player
func get_input() -> void:
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction*speed

	if(Input.is_action_just_pressed("possess")):
		if(crosshair_area.has_overlapping_areas()):
			var overlapping_bodies = crosshair_area.get_overlapping_areas()
			var top_area: Area2D = overlapping_bodies[0]
			for item in overlapping_bodies:
				if(item.position.y > top_area.position.y):
					top_area = item
			#	Get CharacterCommon reference from the PossessionHighlight class
			var enemy = top_area as PossessionHighlight
			if(enemy != null):
				var enemy_character = enemy.CharacterData
				if(enemy_character != null):
					#	Enable enemy as a playable character and delete the player
					enemy_character.is_possessed = true
					enemy_character.ignore_physics_tick = true
					is_possessed = false
					get_parent().queue_free.call_deferred()
					
	if(Input.is_action_pressed("fire") && fire_timer >= fire_timeout):
		var direction = get_global_mouse_position() - position
		projectile_manager.spawn_projectile(position, direction, self)
		fire_timer = 0.0
		print("pew")

func get_health() -> int:
	return health

func show_possession_highlight() -> void:
	if(!is_possessed):
		is_highlighted = possession_area.has_overlapping_areas()

	if(is_possessed || !is_highlighted):
		possession_highlight_sprite.hide()
	if(is_highlighted && !is_possessed):
		possession_highlight_sprite.show()

func take_damage(damageAmount) -> void:
	if(damageAmount > health):
		health = 0
	else:
		health -= damageAmount

func _update_sprites() -> void:
	#	Set crosshair position to cursor position
	if(crosshair!= null):
		crosshair.position = get_global_mouse_position()
	
	#	Flip the sprite depending on the mouse position
	if(player_sprite != null):
		if(position > get_global_mouse_position()):
			player_sprite.flip_h = true
		else:
			player_sprite.flip_h = false
			
func get_z() -> float:
	return player_sprite.position.y

func check_health_for_death() -> void:
	if(health <= 0):
		if(!is_possessed):
			get_owner().queue_free()
		else:
			get_owner().queue_free()
			#	TODO: Do not destroy player, end game instead.

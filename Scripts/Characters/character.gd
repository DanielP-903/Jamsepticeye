class_name Character extends CharacterCommon

@export var collider: CollisionShape2D
@export var overhead_health: ProgressBar

var active = false

func is_active() -> bool:
	return active

func activate() -> void:
	set_physics_process(true)
	set_process(true)
	collider.set_deferred("disabled", false)
	set_deferred("disabled", false)
	
	health = 100
	
	overhead_health.value = health
	
	possession_highlight_sprite.self_modulate = Color.TRANSPARENT
	
	if !is_possessed:
		overhead_health.show()
	else:
		overhead_health.hide()
	
	self.show()
	
	last_enemy_fire_time = Time.get_ticks_msec()
	current_time_between_fire = randi_range(3000, 6000)
	
	possession_area.set_collision_layer_value(1, is_possessed)
	possession_area.set_collision_layer_value(2, !is_possessed)
	set_collision_layer_value(1, is_possessed)
	set_collision_layer_value(2, !is_possessed)
	
	sprite.modulate = Global.friendly_colour if is_possessed else Global.enemy_colour

	active = true
	#print("Activated: " + name)

func deactivate() -> void:
	set_physics_process(false)
	set_process(false)
	collider.set_deferred("disabled", true)
	set_deferred("disabled", true)
	
	overhead_health.value = 0
	overhead_health.hide()
	
	is_possessed = false

	self.hide()
	
	possession_area.set_collision_layer_value(1, false)
	possession_area.set_collision_layer_value(2, false)
	set_collision_layer_value(1, false)
	set_collision_layer_value(2, false)
	
	position = Vector2(-200,-200)
	active = false
	#print("Deactivated: " + name)

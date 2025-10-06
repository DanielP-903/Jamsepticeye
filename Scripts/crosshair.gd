class_name Crosshair extends Area2D

var hovered_character: Character

func _ready() -> void:
	hovered_character = null

func _process(delta: float) -> void:
	# Set crosshair position to cursor position
	position = get_global_mouse_position()

func _input(event: InputEvent) -> void:
	if !Global.game_state_controller.is_playing_game():
		return
	
	var player: Character = Global.game_state_controller.get_player()
	if !player:
		return 
	
	if event.is_action_pressed("possess"):
		if hovered_character and hovered_character.health <= 50.0:
			hovered_character.possess()
			hovered_character.health = 100
			player.unpossess()
			Global.enemy_manager.on_enemy_killed(true)
			#var overlapping_bodies = get_overlapping_areas()
			#var top_area: Area2D = overlapping_bodies[0]
			#for item in overlapping_bodies:
				#if(item.position.y > top_area.position.y):
					#top_area = item
			#	Get CharacterCommon reference from the PossessionHighlight class
			#var enemy = top_area as PossessionHighlight
			#if(enemy != null):
				#var enemy_character = enemy.CharacterData
				#if(enemy_character != null):
					##	Enable enemy as a playable character and delete the player
					#enemy_character.possess()
					#player.unpossess()

func _on_body_entered(body: Node2D) -> void:
	if body is Character:
		if !(body as Character).is_possessed:
			hovered_character = body
			hovered_character.show_possession_highlight()

func _on_body_exited(body: Node2D) -> void:
	if body == hovered_character:
		hovered_character.hide_possession_highlight()
		hovered_character = null

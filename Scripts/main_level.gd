extends Node2D

func _ready() -> void:
	Global.audio_manager.play_music(Global.EMusicType.music1)
	Global.game_state_controller.change_gui(Global.EGUIType.InGame)
	Global.enemy_manager.reset()
	Global.enemy_manager.begin_next_wave_coundown()
	Global.game_state_controller.get_hud().set_health_percent(100)
	Global.game_state_controller.get_hud().set_wave_number(1)
	Global.game_state_controller.get_hud().set_enemies_left(0)
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)

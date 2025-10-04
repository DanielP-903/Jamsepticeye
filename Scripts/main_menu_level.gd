extends Node2D

func _ready() -> void:
	Global.audio_manager.play_music(Global.EMusicType.music2)
	Global.game_state_controller.change_gui(Global.EGUIType.MainMenu)

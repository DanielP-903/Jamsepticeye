class_name HUD extends CanvasLayer

@export var health_bar: ProgressBar
@export var wave_number_text: Label
@export var enemies_left_text: Label

@export var main_hud: MarginContainer
@export var pause_menu: MarginContainer
@export var game_over_menu: MarginContainer

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED

func set_health_percent(percent: float) -> void:
	health_bar.value = percent

func set_enemies_left(left: int) -> void:
	enemies_left_text.text = str(left)

func set_wave_number(wave: int) -> void:
	wave_number_text.text = str(wave)

func toggle_pause_menu():
	Global.game_state_controller.toggle_visibility(main_hud)
	Global.game_state_controller.toggle_visibility(pause_menu)
	
	if Global.game_state_controller.paused:
		pause_menu.on_opened()

func show_game_over_screen():
	Global.game_state_controller.toggle_visibility(main_hud)
	Global.game_state_controller.toggle_visibility(game_over_menu)
	game_over_menu.on_opened()

func _on_hover() -> void:
	Global.audio_manager.play_audio(Global.EAudioType.button_hover)

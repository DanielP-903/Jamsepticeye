class_name HUD extends CanvasLayer

@export var main_hud: MarginContainer
@export var pause_menu: MarginContainer

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED

func toggle_pause_menu():
	Global.game_state_controller.toggle_visibility(main_hud)
	Global.game_state_controller.toggle_visibility(pause_menu)

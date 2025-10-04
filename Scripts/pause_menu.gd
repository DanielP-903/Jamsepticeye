extends MarginContainer

@export var quit_button: Button
@export var resume_button: Button

func _process(delta: float) -> void:
	if !Global.game_state_controller.paused:
		return
	
	Global.game_state_controller.button_hover(quit_button, Global.EButtonTweenType.ScaleOut,  1.2, 0.2)
	Global.game_state_controller.button_hover(resume_button, Global.EButtonTweenType.ScaleOut,  1.2, 0.2)


func _on_resume_button_pressed() -> void:
	Global.game_state_controller.request_toggle_pause()


func _on_quit_button_pressed() -> void:
	Global.game_state_controller.request_toggle_pause()
	Global.game_state_controller.change_level(Global.ELevelType.MainMenu)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

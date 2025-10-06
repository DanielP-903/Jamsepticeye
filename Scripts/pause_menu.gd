extends MarginContainer

@export var quit_button: Button
@export var resume_button: Button

func on_opened() -> void:
	resume_button.grab_focus()

func _process(delta: float) -> void:
	if !Global.game_state_controller.paused:
		return
	
	Global.game_state_controller.button_hover(quit_button, Global.EButtonTweenType.ScaleOut,  1.1, 0.1)
	Global.game_state_controller.button_hover(resume_button, Global.EButtonTweenType.ScaleOut,  1.1, 0.1)
	
	_update_focus()

func _update_focus() -> void:
	if Global.input_helper.is_using_mouse():
		if Input.mouse_mode != Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			# Grab a button and release the focus
			resume_button.grab_focus()
			resume_button.release_focus()		
			# Enable mouse hover
			resume_button.mouse_filter = Control.MOUSE_FILTER_STOP
			quit_button.mouse_filter = Control.MOUSE_FILTER_STOP
	else:
		if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			var has_set_focus = false
			if resume_button.is_hovered():
				resume_button.grab_focus()
				has_set_focus = true
			if quit_button.is_hovered():
				quit_button.grab_focus()
				has_set_focus = true
			# Disable mouse hover
			resume_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
			quit_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
			if !has_set_focus:
				# Nothing was hovered, default to initial button (TODO: could have this go to the last hovered button)
				resume_button.grab_focus()

func _on_resume_button_pressed() -> void:
	Global.game_state_controller.request_toggle_pause()
	Global.audio_manager.play_audio(Global.EAudioType.button_click)


func _on_quit_button_pressed() -> void:
	Global.game_state_controller.request_toggle_pause()
	Global.game_state_controller.change_level(Global.ELevelType.MainMenu)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	Global.audio_manager.play_audio(Global.EAudioType.button_click)

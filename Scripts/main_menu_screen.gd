extends MarginContainer

@export var play_button: Button
@export var options_button: Button
@export var exit_button: Button

var menu_buttons: Array


func _ready() -> void:
	menu_buttons = [play_button, options_button, exit_button]

func _process(delta: float) -> void:
	_update_focus()
	_update_buttons()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		Global.audio_manager.play_audio(Global.EAudioType.test1)
	if event.is_action_pressed("ui_accept"):
		Global.audio_manager.play_audio(Global.EAudioType.test2)
	if event.is_action_pressed("fire"):
		Global.audio_manager.stop_all_audio()

func _update_focus() -> void:
	if Global.input_helper.is_using_mouse():
		if Input.mouse_mode != Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			# Grab a button and release the focus
			menu_buttons[0].grab_focus()
			menu_buttons[0].release_focus()		
			for button in menu_buttons:
				# Enable mouse hover
				button.mouse_filter = 0
	else:
		if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			var has_set_focus = false
			for button in menu_buttons:
				if button.is_hovered():
					button.grab_focus()
					has_set_focus = true
				# Disable mouse hover
				button.mouse_filter = 2
			if !has_set_focus:
				# Nothing was hovered, default to initial button (TODO: could have this go to the last hovered button)
				menu_buttons[0].grab_focus()

func _update_buttons() -> void:
	for button in menu_buttons:
		button_hover(button, 15, 0.1)

func button_hover(button: Button, tween_amount, duration) -> void:
	if !button:
		return
	
	if button.has_focus() || button.is_hovered():
		tween(button, "position", Vector2(tween_amount, button.position.y), duration)
	else:
		tween(button, "position",Vector2(0, button.position.y), duration)

func tween(button, property, amount, duration) -> void:
	var new_tween = create_tween()
	new_tween.tween_property(button, property, amount, duration)

func _on_play_button_pressed() -> void:
	Global.game_state_controller.change_world("res://Levels/dan-test.tscn")

func _on_options_button_pressed() -> void:
	# TODO
	pass

func _on_exit_button_pressed() -> void:
	get_tree().quit()

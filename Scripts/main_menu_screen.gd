extends MarginContainer

@export var title: MarginContainer

@export var main_menu: MarginContainer
@export var options_menu: MarginContainer

@export var play_button: Button
@export var options_button: Button
@export var exit_button: Button

var menu_buttons: Array

var title_pulse = 0.0
var title_pos: Vector2

func _ready() -> void:
	menu_buttons = [play_button, options_button, exit_button]

func _process(delta: float) -> void:
	_update_focus()
	_update_buttons()
	
	title_pulse += delta
	
	if title_pulse > PI:
		title_pulse = 0.0
		
	title.position = Vector2(title.position.x, sin(title_pulse) * -5.0)

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
		Global.game_state_controller.button_hover(button, Global.EButtonTweenType.MoveRight, 15, 0.1)

func _on_play_button_pressed() -> void:
	Global.game_state_controller.change_level(Global.ELevelType.MainLevel)
	Global.audio_manager.play_audio(Global.EAudioType.button_click)

func _on_options_button_pressed() -> void:
	Global.game_state_controller.toggle_visibility(main_menu)
	Global.game_state_controller.toggle_visibility(options_menu)
	Global.audio_manager.play_audio(Global.EAudioType.button_click)

func _on_exit_button_pressed() -> void:
	Global.audio_manager.play_audio(Global.EAudioType.button_click)
	get_tree().quit()

func _on_go_back_button_pressed() -> void:
	Global.game_state_controller.toggle_visibility(main_menu)
	Global.game_state_controller.toggle_visibility(options_menu)
	Global.audio_manager.play_audio(Global.EAudioType.button_click)


func _on_hovered() -> void:
	Global.audio_manager.play_audio(Global.EAudioType.button_hover)

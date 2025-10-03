extends MarginContainer

@export var play_button: Button
@export var options_button: Button
@export var exit_button: Button

var menu_buttons: Array

func _ready():
	menu_buttons = [play_button, options_button, exit_button]
	play_button.grab_focus.call_deferred()

func _process(delta: float) -> void:
	for button in menu_buttons:
		button_hover(button, 15, 0.1)
		
func button_hover(button: Button, tween_amount, duration):
	if !button:
		return
	
	if button.has_focus():
		tween(button, "position", Vector2(tween_amount, button.position.y), duration)
	else:
		tween(button, "position",Vector2(0, button.position.y), duration)

func tween(button, property, amount, duration):
	var new_tween = create_tween()
	new_tween.tween_property(button, property, amount, duration)


func _on_play_button_pressed() -> void:
	Global.game_state_controller.change_world("res://Levels/dan-test.tscn")

func _on_options_button_pressed() -> void:
	# TODO
	pass

func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_exit_button_mouse_entered() -> void:
	exit_button.grab_focus()


func _on_options_button_mouse_entered() -> void:
	options_button.grab_focus()


func _on_play_button_mouse_entered() -> void:
	play_button.grab_focus()

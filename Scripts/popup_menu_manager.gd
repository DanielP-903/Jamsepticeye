extends MarginContainer

@export var menu_screen: VBoxContainer
@export var open_menu_screen: VBoxContainer
@export var help_menu: MarginContainer

@export var open_menu_button: Button
@export var close_menu_button: Button

@export var open_help_menu_button: Button
@export var close_help_menu_button: Button
# etc

var in_menu_buttons: Array
var close_menu_buttons: Array
var toggle_popupmenu_buttons: Array

func _ready():
	in_menu_buttons = [open_help_menu_button]
	toggle_popupmenu_buttons = [open_menu_button, close_menu_button]
	close_menu_buttons = [close_help_menu_button]

func _process(_delta: float):
	update_button_scale()

func update_button_scale():
	for button in in_menu_buttons:
		button_hover(button, 1.2, 0.2)
	for button in toggle_popupmenu_buttons:
		button_hover(button, 1.8, 0.3)
	for button in close_menu_buttons:
		button_hover(button, 1.5, 0.2)

func button_hover(button: Button, tween_amount, duration):
	if !button:
		return
	
	button.pivot_offset = button.size/2.0
	
	if button.is_hovered():
		tween(button, "scale", Vector2.ONE * tween_amount, duration)
	else:
		tween(button, "scale", Vector2.ONE, duration)

func tween(button, property, amount, duration):
	var new_tween = create_tween()
	new_tween.tween_property(button, property, amount, duration)

func toggle_visibility(object):
	if !object:
		return
	
	var anim = $AnimationPlayer
	var animation_type: String
	
	if object.visible:
		animation_type = "close_"
	else:
		animation_type = "open_"
	
	print(animation_type + str(object.name))
	anim.play(animation_type + str(object.name))

func _on_toggle_menu_button_pressed():
	toggle_visibility(menu_screen)

func _on_toggle_help_menu_button_pressed() -> void:
	toggle_visibility(help_menu)

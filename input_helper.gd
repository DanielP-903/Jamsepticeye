class_name InputHelper extends Node

static var using_mouse = false

var previous_using_mouse = false

func _ready() -> void:
	Global.input_helper = self

	# Similar to tick during pause in UE
	process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event: InputEvent) -> void:
	# Checking for input type
	if event is InputEventMouseButton or event is InputEventMouseMotion:
		using_mouse = true
	elif event is InputEventKey or event is InputEventJoypadButton or (event is InputEventJoypadMotion && _check_deadzone()):
		using_mouse = false
	
	previous_using_mouse = using_mouse

func _check_deadzone() -> bool:
	var deadzone_value = 0.5
	var joystick_left_x = Input.get_joy_axis(0, JoyAxis.JOY_AXIS_LEFT_X)
	var joystick_left_y = -Input.get_joy_axis(0, JoyAxis.JOY_AXIS_LEFT_Y)
	
	# Use distance between joystick x and y to determine if we've passed the deadzone value
	var joystick_value = Vector2(joystick_left_x, joystick_left_y).length()
	return deadzone_value < joystick_value

func is_using_mouse() -> bool:
	return using_mouse

func has_input_changed() -> bool:
	return using_mouse != previous_using_mouse

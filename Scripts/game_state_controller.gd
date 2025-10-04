class_name GameController extends Node

@export var level_defs: Dictionary[Global.ELevelType, PackedScene]
@export var gui_defs: Dictionary[Global.EGUIType, PackedScene]

@export var level: Node2D
@export var gui: Control

var current_level_scene
var current_gui_scene

var current_level_type: Global.ELevelType

var paused: bool

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	Global.game_state_controller = self
		
	# Load our initial scene as defined
	change_level(Global.ELevelType.MainMenu)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		request_toggle_pause()

func request_toggle_pause():
	if current_level_type != Global.ELevelType.MainLevel:
		# We only pause in the main level, nowhere else
		return
	
	paused = !paused
	
	# Actually pause/unpause the level
	level.get_tree().paused = paused
	
	# Change mouse capturing
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE if paused else Input.MOUSE_MODE_CONFINED_HIDDEN)
	
	Global.audio_manager.toggle_pause_music_filter()
	
	# Show/hide the UI
	if current_gui_scene is HUD:
			current_gui_scene.toggle_pause_menu()

## UI Helpers START
func button_hover(button: Button, tween_type: Global.EButtonTweenType, tween_amount, duration) -> void:
	if !button:
		return
	
	var type: String
	var open_vec: Vector2
	var close_vec: Vector2
	
	match tween_type:
		Global.EButtonTweenType.MoveRight:
			type = "position"
			open_vec = Vector2(tween_amount, button.position.y)
			close_vec = Vector2(0, button.position.y)
		Global.EButtonTweenType.ScaleOut:
			type = "scale"
			open_vec = Vector2.ONE * tween_amount
			close_vec = Vector2.ONE
			button.pivot_offset = button.size/2.0
	
	if button.has_focus() || button.is_hovered():
		tween(button, type, open_vec, duration)
	else:
		tween(button, type, close_vec, duration)

func tween(button, property, amount, duration) -> void:
	var new_tween = create_tween()
	new_tween.tween_property(button, property, amount, duration)

func toggle_visibility(object):
	if !object:
		return
	
	if object.visible:
		object.visible = false
	else:
		object.visible = true
## UI Helpers END

func change_gui(gui_type: Global.EGUIType, load_type: Global.ESceneChange = Global.ESceneChange.Replace) -> void:
	if gui_defs.get(gui_type) == null:
		push_error("GUI " + Global.EGUIType.keys()[gui_type] + " doesn't exist in the defs!")
		return
	
	if current_gui_scene:
		if load_type == Global.ESceneChange.Replace:
			# Clear all GUIs to be replaced with the new one
			current_gui_scene.queue_free()
		else:
			# Hide the current UI
			current_gui_scene.visible = false
	
	# Create the new GUI
	var new_gui = gui_defs[gui_type].instantiate()
	gui.add_child(new_gui)
	current_gui_scene = new_gui

func change_level(level_type: Global.ELevelType, load_type: Global.ESceneChange = Global.ESceneChange.Replace) -> void:
	if level_defs.get(level_type) == null:
		push_error("Level " + Global.ELevelType.keys()[level_type] + " doesn't exist in the defs!")
		return
	
	if current_level_scene != null:
		if load_type == Global.ESceneChange.Replace:
			# Clear all levels to be replaced with the new one
			current_level_scene.queue_free()
	
	if current_gui_scene != null:
		if load_type == Global.ESceneChange.Replace:
			# Clear all GUI for the loading process
			current_gui_scene.queue_free()
	
	# Stop all audio / vfx
	Global.audio_manager.stop_all_audio(true)
	Global.vfx_manager.stop_all_vfx()
	
	# Create the new level
	var loading_screen = Global.loading_screen.instantiate()
	gui.add_child(loading_screen)
	loading_screen.begin_loading(level_defs[level_type].resource_path, level_type)
	current_level_type = Global.ELevelType.Loading

func finalise_transition(scene, level_type: Global.ELevelType):
	if gui.get_child_count() > 0:
		gui.get_child(0).queue_free()
	var new_scene = scene.instantiate()
	level.add_child(new_scene)
	current_level_scene = new_scene
	current_level_type = level_type

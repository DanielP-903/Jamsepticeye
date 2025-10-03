class_name GameController extends Node

@export var world: Node2D
@export var gui: Control

var current_world_scene
var current_gui_scene

func _ready() -> void:
	Global.game_state_controller = self
		
	# Load our initial scene as defined
	change_gui("res://Levels/main-menu.tscn")

func change_gui(gui_name: String, load_type: Global.ESceneChange = Global.ESceneChange.Replace) -> void:
	if current_gui_scene:
		if load_type == Global.ESceneChange.Replace:
			# Clear all GUIs to be replaced with the new one
			current_gui_scene.queue_free()
		else:
			# Hide the current UI
			current_gui_scene.visible = false
	
	# Create the new GUI
	var new_gui = load(gui_name).instantiate()
	gui.add_child(new_gui)
	current_gui_scene = new_gui

func change_world(world_name: String, load_type: Global.ESceneChange = Global.ESceneChange.Replace) -> void:
	if current_world_scene != null:
		if load_type == Global.ESceneChange.Replace:
			# Clear all Worlds to be replaced with the new one
			current_world_scene.queue_free()
	
	if current_gui_scene != null:
		if load_type == Global.ESceneChange.Replace:
			# Clear all GUI for the loading process
			current_gui_scene.queue_free()
	
	# Create the new world
	var loading_screen = Global.loading_screen.instantiate()
	gui.add_child(loading_screen)
	loading_screen.begin_loading(world_name)

func finalise_transition(scene):
	var new_scene = scene.instantiate()
	world.add_child(new_scene)
	current_world_scene = new_scene

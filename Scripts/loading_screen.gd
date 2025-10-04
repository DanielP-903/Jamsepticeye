extends CanvasLayer

@export var progressBar: ProgressBar

var to_load: String

func begin_loading(world_name: String):
	to_load = world_name
	ResourceLoader.load_threaded_request(to_load)
	
func _process(delta: float):
	var progress = []
	ResourceLoader.load_threaded_get_status(to_load, progress)
	
	progressBar.value = progress[0] * 100
	
	if progress[0] == 1:
		var fresh_scene = ResourceLoader.load_threaded_get(to_load)
		Global.game_state_controller.finalise_transition(fresh_scene)

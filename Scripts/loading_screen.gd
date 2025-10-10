extends CanvasLayer

@export var progressBar: ProgressBar

var loading_level_type: Global.ELevelType
var to_load: String
var finished_loading: bool
var finished_time: float

func begin_loading(world_name: String, type: Global.ELevelType):
	finished_loading = false
	to_load = world_name
	loading_level_type = type
	ResourceLoader.load_threaded_request(to_load)
	print("begun loading")
	
func _process(delta: float):
	if finished_loading:
		if Time.get_ticks_msec() - finished_time > 500:
			var fresh_scene = ResourceLoader.load_threaded_get(to_load)
			Global.game_state_controller.finalise_transition(fresh_scene, loading_level_type)
		return
	
	var progress = []
	ResourceLoader.load_threaded_get_status(to_load, progress)
	
	progressBar.value = progress[0] * 100
	print("loading " + str(progressBar.value) + "%")

	if progress[0] == 1:
		finished_loading = true
		finished_time = Time.get_ticks_msec()
		print("finished loading")
	

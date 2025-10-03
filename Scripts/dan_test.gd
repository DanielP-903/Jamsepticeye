extends Node2D

var last_spawn_time = 0.0

func _ready() -> void:
	Global.audio_manager.play_music(Global.EMusicType.music1)

func _process(delta: float) -> void:
	if Time.get_ticks_msec() - last_spawn_time > 5000.0:
		last_spawn_time = Time.get_ticks_msec()
		Global.vfx_manager.play_vfx(Global.EVFXType.sparkles, $Player.position)

extends Node

var loading_screen = preload("res://Levels/loading.tscn")

var game_state_controller: GameController
var audio_manager: AudioManager
var vfx_manager: VFXManager

var input_helper: InputHelper

enum ESceneChange {Replace, Additive}

# TODO add more audio and music types
enum EAudioType {INVALID, test1, test2}
enum EMusicType {INVALID, music1, music2}

enum EVFXType {INVALID, sparkles, test2}

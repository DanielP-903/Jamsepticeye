extends Node

var loading_screen = preload("res://Scenes/UI/loading.tscn")

var game_state_controller: GameController
var audio_manager: AudioManager
var vfx_manager: VFXManager
var projectile_manager: ProjectileManager
var enemy_manager: EnemyManager

var input_helper: InputHelper

enum EButtonTweenType {MoveRight, ScaleOut}

enum ESceneChange {Replace, Additive}

enum ELevelType {INVALID, MainMenu, MainLevel, Loading}
enum EGUIType {INVALID, MainMenu, InGame}

# TODO add more audio and music types
enum EAudioType {INVALID, test1, test2}
enum EMusicType {INVALID, music1, music2}

enum EVFXType {INVALID, sparkles, test2}

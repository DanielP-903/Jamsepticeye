extends Node

var loading_screen = load("res://Scenes/UI/loading.tscn")

var friendly_colour: Color = Color(0.0, 0.76470588235, 0.86274509803, 1.0)
var enemy_colour: Color = Color(1.0, 0.54901960784, 0.2431372549, 1.0)

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

enum EAudioType {INVALID, button_click, button_hover, fire, game_over, player_hit, enemy_hit, enemy_death, enemy_possessed}
enum EMusicType {INVALID, music1, music2}

enum EVFXType {INVALID, hurt, possess}

extends Node

var loading_screen = preload("res://Levels/loading.tscn")

var game_state_controller: GameController	

enum SceneChange {Replace, Additive}

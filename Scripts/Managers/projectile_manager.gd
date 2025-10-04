class_name ProjectileManager extends Node

var projectile = preload("res://Scenes/Managers/projectile.tscn")
var projectile_pool: Array[Projectile] = []

const pool_size = 10

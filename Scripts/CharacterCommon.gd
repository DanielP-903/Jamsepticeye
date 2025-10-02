extends CharacterBody2D

class_name CharacterCommon

@export var health: int = 100;
@export var speed: int = 100;
var is_possessed: bool = false;

func _physics_process(_delta) -> void:
	if(is_possessed):
		get_input()
		move_and_slide()

#	Move the player
func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction*speed

func getHealth() -> int:
	return health

func takeDamage(damageAmount) -> void:
	if(damageAmount > health):
		health = 0
	else:
		health -= damageAmount

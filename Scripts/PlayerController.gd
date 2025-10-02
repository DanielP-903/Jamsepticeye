extends CharacterBody2D

@export var speed = 400
@onready var player_sprite = $Sprite2D
@onready var crosshair = $Crosshair

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction*speed
	
func _physics_process(delta):
	get_input()
	move_and_slide()
	look_at(get_global_mouse_position())
	
	#	Set crosshair position to cursor position
	$"../Node/Crosshair".position = get_global_mouse_position()
	
	#	Flip the sprite depending on the mouse position
	if(position > get_global_mouse_position()):
		player_sprite.flip_v = true
	else:
		player_sprite.flip_v = false
	

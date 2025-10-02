extends CharacterCommon

@onready var player_sprite = $Sprite2D
@onready var crosshair = $Crosshair

func _init() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
	is_possessed = true

func _process(_delta) -> void:
	_update_sprites()

func _update_sprites() -> void:
	#	Set crosshair position to cursor position
	$"../Node/Crosshair".position = get_global_mouse_position()
	
	#	Flip the sprite depending on the mouse position
	if(position > get_global_mouse_position()):
		player_sprite.flip_h = true
	else:
		player_sprite.flip_h = false

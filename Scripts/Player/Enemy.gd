extends CharacterCommon

class_name Enemy

#@onready var target = $Player
#var is_highlighted: bool = false;

#func ai_get_direction():
#	return target.position - self.position
	
#func ai_move():
	#var direction = ai_get_direction()
	#var motion =  direction.normalized() * speed
	#move_and_slide(motion)
	
#func _physics_process(delta):
	#ai_move


#--------todo--------
#	enable visibility of possessionHighlight when pressing CTRL+mouse cursors is over it

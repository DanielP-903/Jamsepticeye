extends Area2D

class_name PossessionHighlight

@export var CharacterData: CharacterCommon

#var PossessionHighlight = GetParent

#func has_overlapping_areas():
	#CharacterData.is_highlighted = true
	

		

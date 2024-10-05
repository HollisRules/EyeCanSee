@tool
extends Node3D
class_name MainScene

##Current camera mode monster or player
@export var CamOnPlayer : bool = true:
	set(value):
		value = CamOnPlayer
		MoveCamera()
	get:
		return CamOnPlayer

func MoveCamera() -> void:
	pass

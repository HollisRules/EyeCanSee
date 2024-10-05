@tool
extends Node3D

##Current camera mode monster or player
@export var CamOnPlayer : bool = true:
	set(value):
		value = CamOnPlayer
		MoveCamera()
	get:
		return CamOnPlayer

func MoveCamera() -> void:
	pass

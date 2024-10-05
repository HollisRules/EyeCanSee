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

##Ref to player
@export var PlayerRef : Player

##Ref to Monster
@export var MonstRef : Monster

##Ref To Cam
@onready var MainCam : Camera3D = $MainCam

func MoveCamera() -> void:
	if CamOnPlayer:
		print("OnPlay")
		MainCam.global_position = PlayerRef.global_position
		MainCam.global_position.y += 1
	else:
		print("OnMON")
		MainCam.global_position = MonstRef.global_position
		MainCam.global_position.y += 1

func _physics_process(delta: float) -> void:
	if CamOnPlayer:
		MainCam.global_position = PlayerRef.global_position
		MainCam.global_position.y += 1
	else:
		MainCam.global_position = MonstRef.global_position
		MainCam.global_position.y += 1


func _on_perspective_monster_vision_changed(ItSeesHim: bool) -> void:
	if ItSeesHim:
		CamOnPlayer = true
	else:
		CamOnPlayer = false

extends RigidCharacterBody3D
class_name Player

##Max Turn rate in degrees per second
@export var TurnRate : float = 2

##Ref to HeadPOS
@onready var HeadPOSRef : HeadPOS = $HeadPOS

func process_character_input(delta : float):
	input_direction = Input.get_vector("Left","Right","Back","Forward")
	var look_mod : Vector2 = Input.get_vector("LookLeft","LookRight","LookDown","LookUp")
	$HeadPOS.rotate_y(-look_mod.x * TurnRate * delta)
	$TestMesh.rotation.y = $HeadPOS.rotation.y

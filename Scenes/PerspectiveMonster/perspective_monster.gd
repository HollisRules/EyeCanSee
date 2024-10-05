extends RigidCharacterBody3D
class_name Monster
signal VisionChanged (ItSeesHim : bool)

##Ref To Player
@export var playerRef : Player = null

##Ref To Main Scene
@export var mainScene : MainScene = null

##Ref to sight ray
@onready var SightRay : RayCast3D = $HeadPOS/SightRay

##Ref to HeadPOS
@onready var HeadPOSRef : HeadPOS = $HeadPOS

var ItSeesHim : bool = false

func _physics_process(delta: float) -> void:
	super(delta)
	SightRay.target_position = SightRay.to_local(playerRef.HeadPOSRef.global_position)
	DoesItSee()
			

func DoesItSee():
	if SightRay.is_colliding():
		if !ItSeesHim and SightRay.get_collider() is Player:
			ItSeesHim = true
			VisionChanged.emit(ItSeesHim)
		elif ItSeesHim and SightRay.get_collider() is Player:
			ItSeesHim = true
		else:
			ItSeesHim = false
			VisionChanged.emit(ItSeesHim)
	else:
		ItSeesHim = false
		VisionChanged.emit(ItSeesHim)
	print(ItSeesHim)

extends RigidCharacterBody3D

##Ref To Player
@export var playerRef : RigidCharacterBody3D = null

##Ref To Main Scene
@export var mainScene : 

##Ref to sight ray
@onready var SightRay : RayCast3D = $SightRay

func _physics_process(delta: float) -> void:
	super(delta)
	SightRay.target_position = SightRay.to_local(playerRef.global_position)

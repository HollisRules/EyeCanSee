extends RigidCharacterBody3D
class_name Monster
signal VisionChanged (ItSeesHim : bool)
signal KilledPlayer

##Ref To Player
@export var playerRef : Player = null

##Ref To Main Scene
@export var mainScene : MainScene = null

##Ref to camera
@onready var Camera : Camera3D = $MonsterCamera

##Ref to sight ray
@onready var SightRay : RayCast3D = $SightRay

##Ref to nav Agent
@onready var nav : NavigationAgent3D = $NavigationAgent3D

var ItSeesHim : bool = false

func _physics_process(delta: float) -> void:
	super(delta)
	Camera.look_at(playerRef.global_position)
	SightRay.target_position = SightRay.to_local(playerRef.Camera.global_position)
	DoesItSee()
	nav.target_position = playerRef.global_position
	var direction = (nav.get_next_path_position() - global_position).normalized()
	input_direction = Vector2(direction.x, direction.z)

func DoesItSee():
	if SightRay.is_colliding():
		if SightRay.get_collider() == playerRef:
			if !ItSeesHim:
				ItSeesHim = true
				VisionChanged.emit(ItSeesHim)
		else:
			if ItSeesHim:
				ItSeesHim = false
				VisionChanged.emit(ItSeesHim)


func _on_kill_zone_body_entered(body: Node3D) -> void:
	emit_signal("KilledPlayer")

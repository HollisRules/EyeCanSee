extends Node3D
class_name MainScene

##Current camera mode monster or player
var CamOnPlayer : bool = true

##Current camera mode monster or player
var FollowCam : bool = true

##Ref to player
@export var PlayerRef : Player

##Ref to Monster
@export var MonstRef : Monster

##Camera Transition Speed m/s
@export var TranMovementSpeed : float = 1

##Transitioning Bool
@export var Transitioning : bool = false


##Ref To Cam
@onready var Camera : Camera3D = $Camera

##Ref To PLayerCamera
@onready var PlayerCam : Camera3D = PlayerRef.Camera

##Ref To MonsterCamera
@onready var MonstCam : Camera3D = MonstRef.Camera

##If player has the keycard
@onready var KeyCardGrabbed : bool = false

##Tween used for transitioning camera
var tween : Tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)

func _ready() -> void:
	Camera.global_transform = PlayerCam.global_transform
	$WorldEnvironment.environment.ambient_light_color = Color.WHITE
	$WorldEnvironment.environment.ambient_light_energy = .1

func MoveCamera() -> void:
	tween.kill()
	tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
	FollowCam = false
	var GoalTrans : Transform3D = PlayerRef.Camera.global_transform if CamOnPlayer else MonstRef.Camera.global_transform
	var TranDuration : float = Camera.global_position.distance_to(GoalTrans.origin) / TranMovementSpeed
	tween.tween_property(Camera, "global_transform", GoalTrans, TranDuration)
	await tween.finished
	FollowCam = true
	Transitioning = false

func _process(delta: float) -> void:
	if Transitioning:
		MoveCamera()
	if FollowCam:
		if CamOnPlayer:
			Camera.environment = null
			PlayerRef.Model.get_child(0).get_child(0).visible = false
			Camera.set_cull_mask_value(2,false)
			Camera.global_transform = PlayerRef.Camera.global_transform
		else:
			Camera.environment = load("res://MonEnvoir/MonEvoirmentEnvoir.tres")
			PlayerRef.Model.get_child(0).get_child(0).visible = true
			Camera.set_cull_mask_value(2,true)
			Camera.global_transform = MonstRef.Camera.global_transform

func _on_perspective_monster_vision_changed(ItSeesHim: bool) -> void:
	if ItSeesHim:
		CamOnPlayer = false
		PlayerRef.Model.get_child(0).get_child(0).visible = true
	else:
		CamOnPlayer = true
	Transitioning = true


func _on_key_card_key_card_grabbed() -> void:
	KeyCardGrabbed = true
	$IFoundKeyCard.play()
	await $IFoundKeyCard.finished
	$GlassBreaks.play()
	$MonScream.play()
	await $GlassBreaks.finished
	$Lights.visible = false
	$WorldEnvironment.environment.ambient_light_color = Color.RED
	$WorldEnvironment.environment.ambient_light_energy = .03
	$OhSHitPA.play()
	MonstRef.global_position = $MonsterSpawn.global_position
	MonstRef.get_child(7).monitoring = true
	
	
	


func _on_perspective_monster_killed_player() -> void:
	get_tree().change_scene_to_file("res://Scenes/DeathScene/death_scene.tscn")


func _on_win_box_body_entered(body: Node3D) -> void:
	get_tree().change_scene_to_file("res://Scenes/WinScene/win_scene.tscn")


func _on_initial_pa_finished() -> void:
	var tween : Tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
	var GoalPos : Vector3 = $InitialDoor.global_position
	GoalPos.y = 7
	$InitialDoor/AudioStreamPlayer3D.play()
	tween.tween_property($InitialDoor, "global_position", GoalPos, 3)


func _on_area_3d_body_entered(body: Node3D) -> void:
	$"Theres something in the way".play()
	$Area3D.queue_free()

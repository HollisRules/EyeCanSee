@tool
extends Node3D

const InitialPos : Vector3 = Vector3(0,2,0)

enum states{Open,Opening,Closed,Closing}

##The Current State of the door
@export var currentState : states = states.Open :
	set(value):
		currentState = value
		if Engine.is_editor_hint():
			SetDoor()
	get():
		return currentState

##Whether door requires secCard
@export var SecDoor : bool = false:
	set(value):
		SecDoor = value
		if Engine.is_editor_hint():
			if SecDoor:
				$AnimatableBody3D/SecDoorLabel1.visible = true
			else:
				$AnimatableBody3D/SecDoorLabel1.visible = false
	get():
		return SecDoor

##How high the door goes to move
@export var HeightChange : float = 3.75

##Speed Of Door in m/s
@export var DoorSpeed : float = 5

@onready var tween : Tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)

##Only Used For Tool
func SetDoor():
	match currentState:
		states.Open:
			$AnimatableBody3D.position.y = InitialPos.y + HeightChange
		states.Opening:
			currentState = states.Open
			SetDoor()
		states.Closed:
			$AnimatableBody3D.position = InitialPos
		states.Closing:
			currentState = states.Closed
			SetDoor()

func _ready() -> void:
	SetDoor()
	if SecDoor:
		$AnimatableBody3D/SecDoorLabel1.visible = true
	else:
		$AnimatableBody3D/SecDoorLabel1.visible = false

func ToggleDoor():
	$AnimatableBody3D/DoorAudio.play()
	tween.kill()
	tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
	var GoalPos : Vector3 = InitialPos
	var TranDuration : float
	match currentState:
		states.Open:
			GoalPos.y = InitialPos.y
			currentState = states.Closing
		states.Opening:
			GoalPos.y = InitialPos.y
			currentState = states.Closing
		states.Closed:
			GoalPos.y = InitialPos.y + HeightChange
			currentState = states.Opening
		states.Closing:
			GoalPos.y = InitialPos.y + HeightChange
			currentState = states.Opening
	TranDuration = $AnimatableBody3D.position.distance_to(GoalPos) / DoorSpeed
	tween.tween_property($AnimatableBody3D, "position", GoalPos, TranDuration)
	await tween.finished
	if currentState == states.Opening:
		currentState = states.Open
	else:
		currentState = states.Closed


func _on_key_card_reader_card_reader_activate() -> void:
	print("Secdoor " + str(SecDoor) + " Key grabbed " + str(get_parent().KeyCardGrabbed))
	if SecDoor:
		if get_parent().KeyCardGrabbed:
			ToggleDoor()
		else:
			$NeedCardAudio.play()
	else:
		ToggleDoor()

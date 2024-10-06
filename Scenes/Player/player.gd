extends RigidCharacterBody3D
class_name Player

const TargetConst : Vector3 = Vector3(0,0,-1)

##Max Turn rate in degrees per second
@export var TurnRate : float = 2

##Force Mult to move objects
@export var ObjectForceMult : float = 50

##Damp Mult to move objects
@export var ObjectDampMult : float = 5

##Default distance of int cast
@export var DefaultInterDis : float = 5

##Ref to camera
@onready var Camera : Camera3D = $PlayerCamera

##Ref to Interact caster
@onready var InterCast : ShapeCast3D = $PlayerCamera/IntCast

##Ref To Model
@onready var Model : Node3D = $Animated_Main_character

var x_rotation: float
var y_rotation: float

##Ref To utilized object
var UtilObject : Object

##Distance when util object was picked
var UtilObjectDistance : float = 0

##Ref To Util Object Mass
var UtilBodyMass : float = 0

func _ready() -> void:
	super()
	# Capture mouse
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(delta: float) -> void:
	updateCameraTurn()

func process_character_input(delta : float) -> void:
	input_direction = Input.get_vector("Left","Right","Back","Forward")
	if input_direction.length() > 0:
		$Animated_Main_character/AnimationPlayer.play("Take 001")
	else:
		$Animated_Main_character/AnimationPlayer.stop()
	var look_mod : Vector2 = Input.get_vector("LookLeft","LookRight","LookDown","LookUp")
	
	if Input.is_action_just_pressed("Interact"):
		if InterCast.is_colliding():
			UtilObject = InterCast.FindUtilObject()
			if UtilObject is InterArea:
				UtilObject.Interact()
			if UtilObject is InterBody:
				UtilObjectDistance = UtilObject.global_position.distance_to(InterCast.global_position)
				UtilBodyMass = UtilObject.mass
				mass += UtilBodyMass
				InterCast.set_collision_mask_value(5,false)
				InterCast.target_position = TargetConst * UtilObjectDistance
	
	if Input.is_action_pressed("Interact"):
		if UtilObject is InterBody:
			UtilObject.MoveToPoint(InterCast.GetEndPoint(), ObjectForceMult,ObjectDampMult)
	
	if Input.is_action_just_released("Interact"):
		if UtilObject is InterBody:
			mass -= UtilBodyMass
			UtilBodyMass = 0
			UtilObjectDistance = 0
			InterCast.set_collision_mask_value(5,true)
			InterCast.target_position = TargetConst * DefaultInterDis
		UtilObject = null
	
	y_rotation += (-look_mod.x * TurnRate * delta * 10)
	x_rotation += (look_mod.y * TurnRate * delta * 10)

func _input(event) -> void:
	if event is InputEventMouseMotion:
		x_rotation += -event.relative.y * TurnRate * get_process_delta_time()
		y_rotation += -event.relative.x * TurnRate * get_process_delta_time()
		x_rotation = clampf(x_rotation, -80, 80)

func updateCameraTurn() -> void:
	x_rotation = clampf(x_rotation, -80, 80)
	Camera.rotation_degrees.x = x_rotation
	Camera.rotation_degrees.y = y_rotation
	Model.rotation.y = Camera.rotation.y - 170
	

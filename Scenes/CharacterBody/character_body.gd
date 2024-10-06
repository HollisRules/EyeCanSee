@tool
extends RigidBody3D

@export_category("Character Sizing")

##Test Model Visible
@export var TModelVisible : bool = true:
	set(Value):
		TModelVisible = Value
		UpdateCollider()
	get():
		return TModelVisible

##Height Of Character
@export var HeightOfCharacter : float = 2:
	set(Value):
		HeightOfCharacter = Value
		UpdateCollider()
	get():
		return HeightOfCharacter

##Radius Of Character
@export var RadiusOfCharacter : float = .25:
	set(Value):
		RadiusOfCharacter = Value
		UpdateCollider()
	get():
		return RadiusOfCharacter

##Head height from floor where camera is placed
@export var HeadHeight : float = 1.75:
	set(Value):
		HeadHeight = Value
		UpdateCollider()
	get:
		return HeadHeight

##GroundClearance
@export var Clearance : float = .25:
	set(Value):
		Clearance = Value
		UpdateCollider()
	get():
		return Clearance


@export_category("Character Movement")

##Max speed in M/s
@export var MaxSpeed : float = 10

##Max Move Force in N
@export var MaxForce : float = 10

##Movement Speed Damping
@export var SpeedDamp : float = 1

##Jump Force
@export var JumpForce : float = 50

##FloorCastStiffness
@export var Stiffness : float = 50

##Ref To Floor Cast
@onready var FloorCast : RayCast3D = $FloorCast

##Ref To Collider
@onready var Collider : CollisionShape3D = $CollisionShape3D

##Ref To Test Mesh
@onready var TModel : MeshInstance3D = $TestMesh

##Ref To Head Position Node
@onready var HeadPosNode : Node3D = $HeadPosNode

##Goal Velocity
var GoalVelocity : Vector3 = Vector3.ZERO

func _ready():
	# Set up body
	axis_lock_angular_x = true
	axis_lock_angular_y = true
	axis_lock_angular_z = true
	contact_monitor = true
	max_contacts_reported = 16
	continuous_cd = true

##Physics process func
func _physics_process(delta: float) -> void:
	pass
	

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	if IsOnFloor():
		ApplyFloorForce(state)
		DampWrongVelocity()

##Updates Collider Shape
func UpdateCollider() -> void:
	#Update Collider
	Collider.shape.height = HeightOfCharacter - Clearance
	Collider.shape.radius = RadiusOfCharacter
	Collider.position.y = (Collider.shape.height/2) + Clearance
	
	#Update TestMesh
	TModel.visible = TModelVisible
	TModel.mesh.height = Collider.shape.height
	TModel.mesh.radius = RadiusOfCharacter
	TModel.position.y = Collider.position.y
	
	#Update Head Height
	HeadPosNode.position.y = HeadHeight
	
	#Update Floor Cast
	FloorCast.target_position.y = -Clearance -.2
	FloorCast.position.y = Clearance + .1

##Returns whether or not the character is on floor
func IsOnFloor() -> bool:
	if FloorCast.is_colliding():
		FloorCast.get_collider()
		return true
	return false

##Returns the floor the character is standing on
func GetFloor() -> Object:
	if IsOnFloor():
		return FloorCast.get_collider()
	return null

##Returns the global pos of the floor when colliding
func GetFloorPosition() -> Vector3:
	if IsOnFloor():
		return FloorCast.get_collision_point()
	return (FloorCast.global_position + FloorCast.target_position)

##Returns the velocity of the floor
func GetFloorVeloc() -> Vector3:
	var FloorObject : Object = GetFloor()
	if FloorObject == null:
		return Vector3.ZERO
	match FloorObject.get_class():
		"StaticBody3D":
			return Vector3.ZERO
		"RigidBody3D":
			return Vector3.ZERO
		_:
			return Vector3.ZERO

##Returns Head Position
func GetHeadPosition() -> Vector3:
	return HeadPosNode.global_position

##Will apply force in direction of vector in relation to z direction of character
##and will cease to apply force at max speed
func VectorMove(Vector : Vector2) -> void:
	pass

##Will dampen the wrong velocities
func DampWrongVelocity() -> void:
	pass

##Apply Floor Cast Forces (Only Apply if is on floor)
func ApplyFloorForce(state: PhysicsDirectBodyState3D) -> void:
	var DisToClear : float = (
		max(0, Clearance - (FloorCast.global_position.distance_to(GetFloorPosition()) -.1 )))
	
	var force : Vector3 = Vector3(
		0,
		max(-state.get_total_gravity().y * mass, DisToClear * Stiffness * mass),
		0)
	
	print(-state.get_total_gravity().y * mass)
	
	apply_central_force(force)
	var FloorObject : Object = GetFloor()
	if FloorObject is RigidBody3D:
		FloorObject.apply_force(
			-force,
			FloorObject.to_local(GetFloorPosition())
		)

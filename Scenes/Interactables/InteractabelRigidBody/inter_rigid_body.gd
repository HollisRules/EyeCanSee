extends RigidBody3D
class_name InterBody
func MoveToPoint(GoalPos : Vector3, ForceStrength : float = 50, DampMult : float = 5) -> void:
	var damp : Vector3 = linear_velocity * -DampMult
	apply_central_force(((GoalPos - global_position) * ForceStrength) + damp)

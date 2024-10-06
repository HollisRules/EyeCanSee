extends ShapeCast3D
class_name IntCast

func GetEndPoint() -> Vector3:
	var Length : float = get_closest_collision_safe_fraction() * target_position.length()
	return to_global(target_position.normalized() * Length)

##Finds the utilized object of the int cast
func FindUtilObject() -> Node3D:
	var EndPoint : Vector3 = GetEndPoint()
	var UtilObject : Node3D = null
	var ClosestLength : float = 50000
	for i in get_collision_count():
		if get_collider(i) is InterBody or get_collider(i) is InterArea:
			if get_collider(i).global_position.distance_to(EndPoint) < ClosestLength:
				UtilObject = get_collider(i)
				ClosestLength = UtilObject.global_position.distance_to(EndPoint)
	return UtilObject

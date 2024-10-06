extends SpotLight3D

@export var IntCastRef : ShapeCast3D
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta: float) -> void:
	var FoundUtilObject : Node3D = IntCastRef.FindUtilObject()
	var UtilObject : Node3D = get_parent().UtilObject
	if UtilObject != null:
		lerp
		look_at(UtilObject.global_position)
	elif FoundUtilObject != null:
		look_at(FoundUtilObject.global_position)
	else:
		look_at(IntCastRef.GetEndPoint())

extends InterArea
signal KeyCardGrabbed

func Interact() -> void:
	super()
	emit_signal("KeyCardGrabbed")

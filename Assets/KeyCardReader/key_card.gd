extends InterArea
signal KeyCardGrabbed

func Interact() -> void:
	super()
	emit_signal("KeyCardGrabbed")
	visible = false


func _on_i_found_key_card_finished() -> void:
	queue_free()

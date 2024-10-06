extends InterArea
signal KeyCardGrabbed

func Interact() -> void:
	super()
	emit_signal("KeyCardGrabbed")
	$IFoundKeyCard.play()


func _on_i_found_key_card_finished() -> void:
	queue_free()

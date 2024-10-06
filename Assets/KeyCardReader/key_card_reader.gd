extends InterArea
signal CardReaderActivate

func Interact():
	super()
	emit_signal("CardReaderActivate")

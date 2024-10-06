extends Control

##Bool to keep track of whether or not game is paused
var paused : bool = false

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Pause"):
		print("Button")
		pause()

func pause() -> void:
	if paused:
		print("Not Paused")
		visible = false
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		get_tree().paused = false
	else:
		print("Paused")
		visible = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().paused = true
		$VBoxContainer/RestartButton.grab_focus()
	paused = !paused

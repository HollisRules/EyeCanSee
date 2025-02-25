extends Node3D
func _ready() -> void:
	$AnimationPlayer.play("WinScene")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	$Camera3D/FootStep.stop()
	$Camera3D/HeartBeat.stop()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$WinMenu.show()
	$WinMenu/MarginContainer/VBoxContainer/ToMainMenu.grab_focus()

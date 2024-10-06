extends Node3D
func _ready() -> void:
	$AnimationPlayer.play("WinScene")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$WinMenu.show()

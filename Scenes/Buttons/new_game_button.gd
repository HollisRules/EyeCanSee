extends Button

func _on_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/MainScene/main_level.tscn")

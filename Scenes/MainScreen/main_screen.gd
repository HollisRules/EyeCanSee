extends Control

func _ready() -> void:
	$VBoxContainer/NewGameButton.grab_focus()

func _on_exit_button_pressed() -> void:
	get_tree().quit()

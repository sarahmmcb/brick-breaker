extends Control

var disable_screen := false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_pause_screen") && not disable_screen:
		visible = not visible
		get_tree().paused = not get_tree().paused
	if event.is_action_pressed("ui_cancel") && not visible:
		disable_screen = not disable_screen
		get_tree().paused = not get_tree().paused

extends Control

var disable_screen := false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_pause_screen") && not disable_screen:
		visible = not visible
		get_tree().paused = not get_tree().paused
	if event.is_action_pressed("ui_cancel") && not visible:
		disable_screen = not disable_screen
		get_tree().paused = not get_tree().paused
	if event.is_action_pressed("reset_game") && visible:
		GameManager.reset_game(1)
		GameManager.game_was_reset = true
		get_tree().reload_current_scene()

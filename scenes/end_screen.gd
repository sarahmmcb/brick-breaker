extends Control

@onready
var stats_label = %StatsLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("reset_game") && visible:
		GameManager.reset_game(1)
		GameManager.game_was_reset = true
		get_tree().reload_current_scene()
	
func set_stats_label():
	stats_label.text = \
	  "High Score .................... " + str(GameManager.hi_score) + "\n" \
	+ "Longest Combo ................. " + str(GameManager.longest_combo) + "\n" \
	+ "Longest Streak ................ " + str(GameManager.longest_streak) + "\n" \
	+ "Lives Earned .................. " + str(GameManager.lives_earned) + "\n" \
	+ "Deaths ........................ " + str(GameManager.num_deaths) + "\n" \
	+ "Game Overs .................... " + str(GameManager.num_game_overs)
	

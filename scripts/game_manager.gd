extends Node

var score = 0
var level = 1
var extra_lives = 3
var freeze_powerups = 0
var hi_score = 0
var num_deaths = 0
var num_game_overs = 0
var longest_streak = 0
var longest_combo = 0
var lives_earned = 0
var current_combo = 0
var current_streak = 0
const FINAL_LEVEL := 10
var game_was_reset = false
var lives_label_ball = "[img width=40 height=40]res://assets/ball.png[/img]    "
var freeze_label_brick = "[img width=40 height=40 color=#0000ff]res://assets/brick.png[/img]    "
var paddle_powerup_time_left = 0.0
@onready var message_label = %MessageLabel
@onready var lives_label = %ExtraLives
@onready var freeze_label = %FreezePowerup

func _ready():
	pass

func connect_signals():
	var ball = get_node(^"/root/Level/Ball")
	ball.game_over.connect(_on_game_over)
	ball.died.connect(_on_died)
	ball.freeze_activated.connect(_on_use_freeze_powerup)
	var game_level = get_node(^"/root/Level")
	game_level.level_ready.connect(_on_level_ready)
	game_level.level_beaten.connect(_on_level_beaten)

func add_points(points):
	score += points
	hi_score = score if score > hi_score else hi_score

func subtract_life():
	extra_lives -= 1

func add_life():
	extra_lives += 1
	lives_earned += 1

func add_level():
	level += 1

func _process(_delta: float) -> void:
	$CanvasLayer/ScoreLabel.text = str(score)
	$CanvasLayer/LevelLabel.text = "Level: " + str(level)

func set_lives_label():
	lives_label.text = lives_label_ball + "x " + str(extra_lives)
	
func set_freeze_label():
	freeze_label.text = freeze_label_brick + "x " + str(freeze_powerups)

# in this game we reset at the current level on game over
# rather than restarting back at level 1
func reset_game(new_level):
	GameManager.level = new_level
	score = 0
	extra_lives = 3
	freeze_powerups = 0
	current_streak = 0
	current_combo = 0
	hi_score = 0
	num_deaths = 0
	num_game_overs = 0
	longest_streak = 0
	longest_combo = 0
	lives_earned = 0
	message_label.text = "Press ENTER to start!"
	message_label.visible = true
	$CanvasLayer/LevelLabel.text = "Level: " + str(level)
			
func _on_game_over():
	num_deaths += 1
	num_game_overs += 1
	message_label.text = "Game Over!\nPress ENTER to restart from current level"
	message_label.visible = true

func _on_died():
	extra_lives -= 1
	num_deaths += 1
	set_lives_label()
	longest_streak = current_streak if current_streak > longest_streak else longest_streak

func _on_level_ready():
	var freeze_powerups = get_tree().get_nodes_in_group("Freeze_Powerup")
	for member in freeze_powerups:
		member.freeze_powerup_hit.connect(_on_freeze_powerup_hit)
	
func _on_level_beaten():
	if level == FINAL_LEVEL:
		var end_screen = get_node(^"/root/Level/CanvasLayer/EndScreen")
		end_screen.set_stats_label()
		end_screen.visible = true
	else:
		message_label.text = "You beat level " + str(GameManager.level) + "!"
		message_label.text += "\nPress ENTER to start the next level"
		message_label.visible = true
		level += 1

func _on_freeze_powerup_hit():
	freeze_powerups += 1
	set_freeze_label()
	
func _on_use_freeze_powerup():
	freeze_powerups -= 1
	set_freeze_label()

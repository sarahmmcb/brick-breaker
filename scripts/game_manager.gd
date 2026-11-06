extends Node

var score = 0
var level = 1
var extra_lives = 3
var freeze_powerups = 0
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

func add_points(points):
	score += points

func subtract_life():
	extra_lives -= 1

func add_life():
	extra_lives += 1

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
func reset_game():
	score = 0
	extra_lives = 3
	message_label.text = "Press Space to start!"
	
func _on_game_over():
	message_label.text = "Game Over!\nPress Enter to restart from current level"
	message_label.visible = true

func _on_died():
	extra_lives -= 1
	set_lives_label()

func _on_level_ready():
	var bricks = get_tree().get_nodes_in_group("Brick")
	for member in bricks:
		member.level_beaten.connect(_on_level_beaten)
	var freeze_powerups = get_tree().get_nodes_in_group("Freeze_Powerup")
	for member in freeze_powerups:
		member.freeze_powerup_hit.connect(_on_freeze_powerup_hit)
	
func _on_level_beaten():
	message_label.text = "You beat level " + str(GameManager.level) + "!"
	message_label.text += "\nPress Space to start the next level"
	message_label.visible = true
	level += 1

func _on_freeze_powerup_hit():
	freeze_powerups += 1
	set_freeze_label()
	
func _on_use_freeze_powerup():
	freeze_powerups -= 1
	set_freeze_label()

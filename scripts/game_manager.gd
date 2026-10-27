extends Node

var score = 0
var level = 1
var extra_lives = 3
var lives_label_ball = "[img width=40 height=40]res://assets/ball.png[/img]    "
@onready var message_label = %MessageLabel
@onready var lives_label = %ExtraLives

func _ready():
	pass

func connect_signals():
	var ball = get_node(^"/root/Level/Ball")
	ball.game_over.connect(_on_game_over)
	ball.died.connect(_on_died)
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
	
func _on_level_beaten():
	message_label.text = "You beat level " + str(GameManager.level) + "!"
	message_label.text += "\nPress Space to start the next level"
	message_label.visible = true
	level += 1

extends Node

var score = 0
var level = 1

func add_points(points):
	score += points

func _process(delta: float) -> void:
	$CanvasLayer/ScoreLabel.text = str(score)
	$CanvasLayer/LevelLabel.text = "Level: " + str(level)

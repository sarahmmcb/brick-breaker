extends Node2D

var lives_label_ball = "[img width=40 height=40]res://assets/ball.png[/img]    "
@onready var brick_object = preload("res://scenes/brick.tscn")

var brick_height := 73
var brick_width := 73
var columns = 16
var rows = 5
var side_margin = 200
var top_margin = 200

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_level()

func set_extra_lives():
	for i in range(GameManager.extra_lives):
		GameManager.lives_label.text = lives_label_ball + "x " + str(GameManager.extra_lives)

func setup_level():
	var colors = get_colors()
	colors.shuffle()
	var powerup_colors = get_powerup_colors()
	
	set_extra_lives()
	
	var levels = get_levels()
	var powerups = get_powerups()
	
	if GameManager.level > levels.size():
		GameManager.level = 1
		
	var level = levels[GameManager.level-1]
	var level_powerups = powerups[GameManager.level-1]
	if (level_powerups.size() > 0):
		insert_powerups(level, level_powerups)
	
	var rowNum = 0
	var colNum = 0
	for row in level:
		for col in row:
			if col:
				var new_brick = brick_object.instantiate()
				add_child(new_brick)
				new_brick.position = Vector2(side_margin + (brick_width * colNum), top_margin + (brick_height * rowNum))
			
				var sprite = new_brick.get_node('Sprite2D')
				if level[rowNum][colNum] > 1:
					new_brick.get_node("ShineParticles").emitting = true
					sprite.modulate = powerup_colors[level[rowNum][colNum] - 2]
				else:
					sprite.modulate = colors[rowNum % colors.size()]
			colNum += 1
		rowNum += 1
		colNum = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("skip_level"): # Q
		GameManager.level += 1
		get_tree().reload_current_scene()
	if Input.is_action_just_pressed("beat_level"): # R
		get_tree().get_first_node_in_group("Brick").end_level()
	
"""
`level` is 2D array describing the level
`level_powerups` is 1D array listing the powerups in the level
This function's job to calculate random positions for the powerups
within the level's brick arrangement
"""	
func insert_powerups(level, level_powerups):
	var numRows = level.size()
	var numCols = level[0].size()
	var powerup_positions = []
	for powerup in level_powerups:
		var x = randi_range(0, numRows - 1)
		var y = randi_range(0, numCols - 1)
		while level[x][y] != 1:
			x = randi_range(0, numRows - 1)
			y = randi_range(0, numCols - 1)
		level[x][y] = powerup
	
func get_colors():
	return [
		Color(0,1,1,1),
		Color(1,0.93,0.15,1),
		Color(0.68,1,0.18,1),
		Color(1,0,1,1)
	]

func get_powerup_colors():
	return [
		Color(1,0,0,1), # Paddle Size
		Color(0,1,0,1),  # Velocity Adjust
		Color(0,0,1,1)  # Freeze (paddle still moves)
	]

func get_levels():
	return [level1,level2,level3,level4]
	
var level1 = [
	[1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1],
	[0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0],
	[1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1]	
]

var level2 = [
	[1,0,1,0,1,0,1,0,0,0,0,0,0,0,1,0,1,0,1,0,1],
	[1,1,1,1,1,1,1,0,0,0,0,0,0,0,1,1,1,1,1,1,1],
	[1,0,1,0,1,0,1,0,0,0,0,0,0,0,1,0,1,0,1,0,1],
	[1,1,1,1,1,1,1,0,0,0,0,0,0,0,1,1,1,1,1,1,1],
	[1,0,1,0,1,0,1,0,0,0,0,0,0,0,1,0,1,0,1,0,1],
]

var level3 = [
	[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
	[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
	[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
]

var level4 = [
	[1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0],
	[0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1],
	[1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0],
	[0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1]
]

"""
Powerups are:
	2. Paddle size
	3. Free Restart
	4. Freeze Ball
"""
func get_powerups():
	return [
		level1_powerups,
		level2_powerups,
		level3_powerups,
		level4_powerups
	]
	
var level1_powerups = []
var level2_powerups = [2, 3, 4]
var level3_powerups = []
var level4_powerups = []

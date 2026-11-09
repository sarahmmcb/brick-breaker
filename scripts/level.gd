extends Node2D

@onready var brick_object = preload("res://scenes/brick.tscn")

signal level_ready
signal level_beaten

var brick_height := 73
var brick_width := 73
var columns = 16
var rows = 5
var side_margin = 127
var top_margin = 200

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.connect_signals()
	setup_level()
	if GameManager.game_was_reset:
		GameManager.game_was_reset = false
		%PauseScreen.visible = false
		get_tree().paused = false

func setup_level():
	var colors = get_colors()
	colors.shuffle()
	var powerup_colors = get_powerup_colors()
	
	GameManager.set_lives_label()
	GameManager.set_freeze_label()
	
	var levels = get_levels()
	var powerups = get_powerups()
	
	if GameManager.level > levels.size():
		GameManager.level = 1 # TODO: end the game before this happens
		
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
					new_brick.set_brick_type(level[rowNum][colNum])
				else:
					sprite.modulate = colors[rowNum % colors.size()]
			colNum += 1
		rowNum += 1
		colNum = 0
		
	get_tree().paused = GameManager.level == 1
	%PauseScreen.visible = GameManager.level == 1
	level_ready.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("skip_level"): # Shift + S
		GameManager.add_level()
		get_tree().reload_current_scene()
		return
	if Input.is_action_just_pressed("beat_level"): # Shift + R
		end_level()
		return
	
	var bricks_left = get_tree().get_nodes_in_group("Brick")
	if bricks_left.size() == 0:
		end_level()

func end_level():
	get_node("Ball").is_active = false
	#await get_tree().create_timer(1).timeout
	level_beaten.emit()
	if (GameManager.level != GameManager.FINAL_LEVEL):
		get_tree().reload_current_scene()
	
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
		Color(1,0.93,0.15,1),
		Color(0.68,1,0.18,1),
		Color(0,1,1,1),
		Color(1,0,1,1)
	]

func get_powerup_colors():
	return [
		Color(1,0,0,1), # Bomb
		Color(0.5,0,1,1),  # Wider paddle
		Color(0,0,1,1)  # Freeze (paddle still moves)
	]

func get_levels():
	return [level1,level2,level3,level4,level5,level6,level7,level8,level9,level10]
	
var level1 = [
	[0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0],
	[0,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,0],
	[0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0]	
]

#var level1 = [
	#[0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0],
#]

var level2 = [
	[0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0],
	[1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1],
	[0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0],
	[1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1]
]

var level3 = [
	[0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0],
	[1,0,1,0,1,0,1,0,1,0,0,0,0,0,1,0,1,0,1,0,1,0,1],
	[0,1,0,1,0,1,0,1,0,0,0,0,0,0,0,1,0,1,0,1,0,1,0],
	[1,0,1,0,1,0,1,0,0,0,0,0,0,0,0,0,1,0,1,0,1,0,1],
	[0,1,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,1,0],
	[0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,0],
]

var level4 = [
	[0,1,0,1,0,1,0,1,0,0,0,0,0,0,0,1,0,1,0,1,0,1,0],
	[0,1,1,1,1,1,1,1,0,0,0,0,0,0,0,1,1,1,1,1,1,1,0],
	[0,1,0,1,0,1,0,1,0,0,0,0,0,0,0,1,0,1,0,1,0,1,0],
	[0,1,1,1,1,1,1,1,0,0,0,0,0,0,0,1,1,1,1,1,1,1,0],
	[0,1,0,1,0,1,0,1,0,0,0,0,0,0,0,1,0,1,0,1,0,1,0],
]

var level5 = [
	[0,1,0,1,0,1,0,1,0,0,0,0,0,0,0,1,0,1,0,1,0,1,0],
	[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
	[0,1,0,1,0,1,0,1,0,0,0,0,0,0,0,1,0,1,0,1,0,1,0],
	[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
	[0,1,0,1,0,1,0,1,0,0,0,0,0,0,0,1,0,1,0,1,0,1,0],
]

var level6 = [
	[0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0],
	[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
	[0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0],
	[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
	[0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0],
	[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
]

var level7 = [
	[0,1,1,1,0,0,1,1,1,1,1,1,0,0,1,1,1,1,1,0,0,1,1],
	[0,1,0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1,0,0,0,0,1],
	[0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
	[0,1,1,1,0,0,1,1,0,0,1,1,1,1,0,0,1,1,0,0,1,1,1],
	[0,1,1,1,0,0,1,1,0,0,1,0,0,1,0,0,1,1,0,0,1,1,1],
	[0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
	[0,1,1,1,1,1,0,0,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1],
]

var level8 = [
	[0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
	[0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
	[0,1,0,0,1,1,1,1,1,1,0,0,0,0,1,1,1,1,1,1,0,0,1],
	[0,1,1,1,0,0,1,1,0,0,1,1,1,1,0,0,1,1,0,0,1,1,1],
	[0,1,1,1,0,0,1,1,0,0,1,1,1,1,0,0,1,1,0,0,1,1,1],
	[0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
	[0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
]

var level9 = [
	[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
	[1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,1,1,1],
	[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
	[1,1,1,1,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,1,1,1,1],
	[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
	[1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1],
	[1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1],
	[1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1],
]

var level10 = [
	[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
	[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
	[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
	[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
	[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
	[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
	[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
	[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
]

"""
Powerups are:
	2. Bomb
	3. Wider Paddle
	4. Freeze
"""
func get_powerups():
	return [
		level1_powerups,
		level2_powerups,
		level3_powerups,
		level4_powerups,
		level5_powerups,
		level6_powerups,
		level7_powerups,
		level8_powerups,
		level9_powerups,
		level10_powerups,
	]
	
var level1_powerups = []
var level2_powerups = [3,4]
var level3_powerups = [2,3,4]
var level4_powerups = [2,2,4]
var level5_powerups = [2,2,3,4,4]
var level6_powerups = [2,2,3,3,4,4]
var level7_powerups = [2,2,2,3,3,4,4]
var level8_powerups = [2,2,2,3,3,4,4]
var level9_powerups = [2,2,2,2,3,3,4,4]
var level10_powerups = [2,2,2,2,3,3,3,4,4]

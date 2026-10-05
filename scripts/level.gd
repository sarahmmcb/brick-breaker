extends Node2D

var lives_label_text = "[img width=40 height=40]res://assets/ball.png[/img]    "
@onready var brick_object = preload("res://scenes/brick.tscn")

var columns = 16 # brick is 73 pixels wide and tall
var rows = 5
var margin = 200 # Orig: 50

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_level()

func setup_level():
	var colors = get_colors()
	colors.shuffle()
	
	GameManager.lives_label.text = "";
	for i in range(GameManager.extra_lives):
		GameManager.lives_label.text = GameManager.lives_label.text + lives_label_text
		
	var levels = get_levels()
	
	if GameManager.level > levels.size():
		GameManager.level = 1
		
	var level = levels[GameManager.level-1]
	var rowNum = 0
	var colNum = 0
	for row in level:
		for col in row:
			if col:
				var new_brick = brick_object.instantiate()
				add_child(new_brick)
				new_brick.position = Vector2(margin + (75 * colNum), margin + (75 * rowNum))
			
				var color_number = randi_range(0,3)
				var sprite = new_brick.get_node('Sprite2D')
				sprite.modulate = colors[color_number]
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
	
func get_colors():
	return [
		Color(0,1,1,1),
		Color(1,0.93,0.15,1),
		Color(0.68,1,0.18,1),
		Color(1,1,1,1)
	]

func get_levels():
	return [level1,level2,level3,level4]
	
var level1 = [
	[1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1],
	[0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1],
	[1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1]	
]

var level2 = [
	[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
	[0,1,1,1,0,1,1,1,0,1,1,1,0,1,1,1,0,1,1,1],
	[1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0]
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

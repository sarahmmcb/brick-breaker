extends Node2D

@onready var brick_object = preload("res://scenes/brick.tscn")

var columns = 25 # brick is 73 pixels wide and tall
var rows = 4
var margin = 50

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_level()
	
func setup_level():
	for r in rows:
		for c in columns:
			var new_brick = brick_object.instantiate()
			add_child(new_brick)
			new_brick.position = Vector2(margin + (75 * c), margin + (75 * r))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

extends Node2D

@onready var brick_object = preload("res://scenes/brick.tscn")

var columns = 25 # brick is 73 pixels wide and tall
var rows = 5
var margin = 50

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_level()


func setup_level():
	var colors = get_colors()
	colors.shuffle()
	for r in rows:
		for c in columns:
			var random_number = randi_range(0,3)
			var color_number = randi_range(0,3)
			if random_number % 2 == 0:
				var new_brick = brick_object.instantiate()
				add_child(new_brick)
				new_brick.position = Vector2(margin + (75 * c), margin + (75 * r))
				
				var sprite = new_brick.get_node('Sprite2D')
				sprite.modulate = colors[color_number]
				


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func get_colors():
	return [
		Color(0,1,1,1),
		Color(1,0.93,0.15,1),
		Color(0.68,1,0.18,1),
		Color(1,1,1,1)
	]

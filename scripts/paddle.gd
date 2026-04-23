extends CharacterBody2D

const SPEED = 1000.0
var speed_factor := 7.0
var vertical_position := 0

func _ready():
	var viewport_size = get_viewport().get_visible_rect().size
	vertical_position = viewport_size.y - 100
	position.y = vertical_position

func _process(delta: float) -> void:
	if position.y != vertical_position:
		position.y = vertical_position

func _physics_process(delta: float) -> void:

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	
	var desired_speed := direction * SPEED
	var speed_difference := desired_speed - velocity.x
	var speed_adjust := speed_factor * delta
	if speed_adjust > 1.0:
		speed_adjust = 1.0
	velocity.x += speed_difference * speed_adjust
	

	move_and_slide()

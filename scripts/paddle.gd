extends CharacterBody2D

const SPEED = 1000.0
var speed_factor := 7.0
var vertical_position := 0

func _ready():
	var viewport_size = get_viewport().get_visible_rect().size
	vertical_position = viewport_size.y - 100
	position.y = vertical_position

func _process(_delta: float) -> void:
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
	
	
# Comments on YouTube note the problem with the paddle being pushed down
# Someone said it's because you shouldn't use CharacterBody2D for something 
# so simple as a paddle that just moves left and right. Rather, use
# RigidBody2D or even StaticBody 2D with manual logic:
	
#extends StaticBody2D
#
#@export var speed := 500  # Move speed
#
#func _process(delta):
	#var move_direction = 0
	#if Input.is_action_pressed("ui_left"):
		#move_direction = -1
	#elif Input.is_action_pressed("ui_right"):
		#move_direction = 1
#
	#position.x += move_direction * speed * delta
	#position.x = clamp(position.x, 50, 550)  # Keep it inside screen (I set my screen width 600 pixels) 

extends StaticBody2D

const SPEED := 1000  # Move speed
var speed_factor := 7.0
var velocity := Vector2(0,0) # StaticBody2D doesn't come with a velocity prop

func _ready():
	var sprite: Sprite2D = get_node('Sprite2D')
	sprite.self_modulate = Color(1,1,0.2,1)
	
func _process(delta):
	var direction := 0
	if Input.is_action_pressed("ui_left"):
		direction = -1
	elif Input.is_action_pressed("ui_right"):
		direction = 1
	
	var desired_speed := direction * SPEED
	var speed_difference := desired_speed - velocity.x
	var speed_adjust = speed_factor * delta
	if speed_adjust > 1.0:
		speed_adjust = 1.0
		
	velocity.x += speed_difference * speed_adjust

	position.x += velocity.x * delta
	position.x = clamp(position.x, 100, 1820)  # Keep it inside screen 

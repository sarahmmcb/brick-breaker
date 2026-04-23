extends CharacterBody2D


const SPEED = 1000.0
var speed_factor := 7.0

func _physics_process(delta: float) -> void:

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	
	var desired_speed := direction * SPEED
	var speed_difference := desired_speed - velocity.x
	var speed_adjust := speed_factor * delta
	if speed_adjust > 1.0: speed_adjust = 1.0
	velocity.x += speed_difference * speed_adjust
	

	#if direction:
		#var desired_speed := direction * SPEED
		#velocity.x = desired_speed
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

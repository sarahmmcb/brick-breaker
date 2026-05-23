extends CharacterBody2D

var speed := 500.0
var is_active := false
var last_collider_is_brick := false

func _ready() -> void:
	speed = speed + (20 * GameManager.level)
	$CPUParticles2D.visible = false;
	velocity = Vector2(speed, speed)
	
func _process(_delta: float) -> void:
	if !is_active:
		if Input.is_action_just_pressed("launch"):
			is_active = true;
			$CPUParticles2D.visible = true;
			
	
func _physics_process(delta: float) -> void:
	if is_active:
		var collision = move_and_collide(velocity * delta)
	
		if collision:
			velocity = velocity.bounce(collision.get_normal())
			
			if collision.get_collider().has_method("hit"):
				collision.get_collider().hit()
				if last_collider_is_brick:
					var new_speed = clamp(velocity.length() + (0.1 * velocity.length()), 700.0, 1000.0)
					velocity = velocity.normalized() * new_speed
					
				last_collider_is_brick = true
			else:
				last_collider_is_brick = false
	
			if collision.get_collider() == get_node("../paddleStatic"):
				var angle = velocity.normalized().dot(Vector2.LEFT) if (velocity.x < 0) else velocity.normalized().dot(Vector2.RIGHT)
				if (abs(angle) > 0.8):
					var new_speed = clamp(velocity.length() - (0.1 * velocity.length()), 700.0, 1000.0)
					velocity = velocity.normalized() * new_speed
		
		# If we're not moving much in the y direction, spike it up in the air a bit
		if (velocity.y > 0 and velocity.y < 100):
			velocity.y = -200
		
		# if we're stuck moving up and down, bump it to the side a bit
		if abs(velocity.x) < 100:
			velocity.x = -200
	else:
		position.x = get_node("../paddleStatic").position.x
	

func game_over():
	GameManager.score = 0
	get_tree().reload_current_scene()
	

func _on_death_zone_body_entered(_body: Node2D) -> void:
	call_deferred("game_over")

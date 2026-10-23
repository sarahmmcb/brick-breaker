extends CharacterBody2D

var min_speed := 650.0
var max_speed := 1000.0
var speed := 0
var is_active := false
var is_game_over := false
var last_collider_is_brick := false

func _ready() -> void:
	speed = min_speed + (20 * (GameManager.level - 1))
	velocity = Vector2(speed, speed)
	
func _process(_delta: float) -> void:
	if !is_active:
		if Input.is_action_just_pressed("launch"):
			GameManager.message_label.visible = false
			is_active = true
			
	if is_game_over:
		if Input.is_action_just_pressed("restart_after_game_over"):
			GameManager.score = 0
			GameManager.extra_lives = 3
			GameManager.message_label.text = "Press Space to start!"
			get_tree().reload_current_scene()
	
func _physics_process(delta: float) -> void:
	if is_active:
		var collision = move_and_collide(velocity * delta)
	
		if collision:
			velocity = velocity.bounce(collision.get_normal())
			
			if collision.get_collider().has_method("hit"):
				collision.get_collider().hit()
		
		# If we're not moving much in the y direction, spike it up in the air a bit
		if (velocity.y > 0 and velocity.y < 100):
			velocity.y = -200
		
		# if we're stuck moving up and down, bump it to the side a bit
		if abs(velocity.x) < 100:
			velocity.x = -200
	else:
		position.x = get_node("../paddleStatic").position.x
	
func game_over():
	is_game_over = true
	GameManager.message_label.text = "Game Over!\nPress Enter to restart from current level"
	GameManager.message_label.visible = true

func subtract_life():
	GameManager.extra_lives -= 1
	is_active = false
	position.x = get_node("../paddleStatic").position.x
	position.y = get_node("../paddleStatic").position.y - 53
	velocity = Vector2(speed, speed)
	get_node("..").set_extra_lives()
	
func _on_death_zone_body_entered(_body: Node2D) -> void:
	if (GameManager.extra_lives > 0):
		call_deferred("subtract_life")
	else:
		call_deferred("game_over")

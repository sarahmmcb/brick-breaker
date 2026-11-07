extends CharacterBody2D

signal died
signal game_over
signal level_started
signal freeze_activated

var min_speed := 650.0
var max_speed := 1000.0
var speed := 0
var is_active := false
var is_game_over := false
var last_collider_is_brick := false
var is_frozen := false
var freeze_time := 5.0

func _ready() -> void:
	speed = min_speed + (15 * (GameManager.level - 1))
	velocity = Vector2(speed, speed)
	%FreezeTimer.timeout.connect(_on_freeze_timeout)
	
func _process(_delta: float) -> void:
	if !is_active:
		if Input.is_action_just_pressed("launch"):
			GameManager.message_label.visible = false
			is_active = true
			level_started.emit()
			
	if Input.is_action_just_pressed("freeze") && is_active:
		if GameManager.freeze_powerups > 0:
			%FreezeTimer.start(freeze_time)
			is_frozen = true
			freeze_activated.emit()
			
	if is_game_over:
		if Input.is_action_just_pressed("restart_after_game_over"):
			GameManager.reset_game()
			get_tree().reload_current_scene()
	
func _physics_process(delta: float) -> void:
	if !is_frozen:
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
	
func emit_game_over():
	is_game_over = true
	game_over.emit()

func emit_died():
	is_active = false
	position.x = get_node("../paddleStatic").position.x
	position.y = get_node("../paddleStatic").position.y - 53
	velocity = Vector2(speed, speed)
	died.emit()
	
func _on_death_zone_body_entered(_body: Node2D) -> void:
	if  get_tree().get_nodes_in_group("Brick").size() == 0:
		return
	if (GameManager.extra_lives > 0):
		call_deferred("emit_died")
	else:
		call_deferred("emit_game_over")
		
func _on_freeze_timeout():
	is_frozen = false

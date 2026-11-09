extends RigidBody2D

signal level_beaten
signal paddle_powerup_hit
signal freeze_powerup_hit

var has_been_hit := false
const blast_radius := 75.0 * 3.0 # (brick_width plus a little extra) * multiplier

func award_extra_life():
	if GameManager.score % 100 == 0:
		GameManager.add_life()
		GameManager.set_lives_label()

func hit():
	has_been_hit = true
	#$AudioStreamPlayer2D.play();
	GameManager.add_points(1)
	award_extra_life()
	$ShineParticles.visible = false
	$ShineParticles.emitting = false
	$CPUParticles2D.emitting = true
	$Sprite2D.visible = false
	$CollisionShape2D.disabled = true
	
	if is_power_up():
		handle_power_up()
	
	# wait one second before deleting block from existence
	# we wait this one second bc that is the lifetime of the
	# CPU particles we want to emit when the block is hit
	# If we removed the block right away, the particles wouldn't show
	await get_tree().create_timer(1).timeout
	queue_free()

func is_power_up():
	return get_node(".").is_in_group("Paddle_Powerup") \
		or get_node(".").is_in_group("Bomb_Powerup") \
		or get_node(".").is_in_group("Freeze_Powerup")

func handle_power_up():
	var powerup_node = get_node(".")
	if powerup_node.is_in_group("Paddle_Powerup"):
		paddle_powerup_hit.emit($"../paddleStatic".POWER_UP_S)
	if powerup_node.is_in_group("Bomb_Powerup"):
		_handle_bomb_powerup(powerup_node)
	if powerup_node.is_in_group("Freeze_Powerup"):
		freeze_powerup_hit.emit()
		
func _handle_bomb_powerup(powerup_node: RigidBody2D):
	var all_bricks = get_tree().get_nodes_in_group("Brick")
	for brick in all_bricks:
		if brick != null && brick != powerup_node:
			var distance = brick.position.distance_to(powerup_node.position)
			if brick != null && distance <= blast_radius && !brick.has_been_hit:
				brick.hit() 
				
func set_brick_type(type: int):
	match type:
		2: get_node(".").add_to_group("Bomb_Powerup")
		3: get_node(".").add_to_group("Paddle_Powerup")
		4: get_node(".").add_to_group("Freeze_Powerup")

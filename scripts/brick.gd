extends RigidBody2D

signal level_beaten
signal powerup_hit

var is_level_beaten := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("launch") && level_beaten:
		is_level_beaten = false

func award_extra_life():
	if (GameManager.score % 100 == 0 && GameManager.extra_lives < 3):
		GameManager.add_life()
		GameManager.set_lives_label()

func hit():
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
	
	var bricks_left = get_tree().get_nodes_in_group("Brick")
	
	if bricks_left.size() == 1:
		end_level()
	else:
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
	if get_node(".").is_in_group("Paddle_Powerup"):
		powerup_hit.emit(Enums.Brick_Type.WIDER_PADDLE, $"../paddleStatic".POWER_UP_S)
		
func end_level():
	get_parent().get_node("Ball").is_active = false
	await get_tree().create_timer(1).timeout
	is_level_beaten = true
	level_beaten.emit()
	get_tree().reload_current_scene()
	
func set_brick_type(type: int):
	match type:
		2: get_node(".").add_to_group("Bomb_Powerup")
		3: get_node(".").add_to_group("Paddle_Powerup")
		4: get_node(".").add_to_group("Freeze_Powerup")
		

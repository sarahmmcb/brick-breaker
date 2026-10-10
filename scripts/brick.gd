extends RigidBody2D

var level_beaten = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("launch") && level_beaten:
		level_beaten = false

func award_extra_life():
	if (GameManager.score % 100 == 0 && GameManager.extra_lives < 3):
		GameManager.extra_lives += 1
		$"..".set_extra_lives()

func hit():
	#$AudioStreamPlayer2D.play();
	GameManager.add_points(1)
	award_extra_life()
	$CPUParticles2D.emitting = true
	$Sprite2D.visible = false
	$CollisionShape2D.disabled = true
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
		
func end_level():
	get_parent().get_node("Ball").is_active = false
	await get_tree().create_timer(1).timeout
	var level_beaten = true
	GameManager.message_label.text = "You beat level " + str(GameManager.level) + "!"
	GameManager.message_label.text += "\nPress Space to start the next level"
	GameManager.message_label.visible = true
	GameManager.level += 1
	get_tree().reload_current_scene()		
	

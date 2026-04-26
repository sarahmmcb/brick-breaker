extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func hit():
	
	GameManager.add_points(1)
	$CPUParticles2D.emitting = true
	$Sprite2D.visible = false
	$CollisionShape2D.disabled = true
	var bricks_left = get_tree().get_nodes_in_group("Brick")
	if bricks_left.size() == 1:
		get_parent().get_node("Ball").is_active = false
		await get_tree().create_timer(1).timeout
		GameManager.level += 1
		get_tree().reload_current_scene()
	else:
		# wait one second before deleting block from existence
		# we wait this one second bc that is the lifetime of the
		# CPU particles we want to emit when the block it hit
		# If we removed the block right away, the particles wouldn't show
		await get_tree().create_timer(1).timeout
		queue_free()
		
		
	

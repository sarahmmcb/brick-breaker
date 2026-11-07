extends StaticBody2D

const VIEWPORT_WIDTH := 1900 # TODO: make this programmatic
const POWER_UP_S := 60.0
const MAX_TILT := 0.262 # radians
var speed := 1300  # Move speed
var speed_factor := 7.0
var tilt_amount := 0.05 # radians
var velocity := Vector2(0,0) # StaticBody2D doesn't come with a velocity prop
var width := 551 # sprite is 551 pixels wide

@onready var paddle_sprite: Sprite2D = get_node('Sprite2D')

func _ready():
	width = width * paddle_sprite.scale.x
	var game_level = get_node("..")
	game_level.level_ready.connect(_on_level_ready)
	if (GameManager.level > 5):
		speed *= 1.25
	if (GameManager.paddle_powerup_time_left > 0.0):
		_handle_wider_paddle(GameManager.paddle_powerup_time_left)
		%PowerupTimer.set_paused(true)
		%LabelUpdateTimer.set_paused(true)
		GameManager.paddle_powerup_time_left = 0.0

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("launch"):
		%PowerupTimer.set_paused(false)
		%LabelUpdateTimer.set_paused(false)
	if Input.is_action_just_pressed("level_paddle"):
		rotation = 0.0

func _physics_process(delta):
	var direction := 0
	var tilt_dir := 0
	
	if Input.is_action_pressed("ui_left"):
		direction = -1
	elif Input.is_action_pressed("ui_right"):
		direction = 1
	
	if Input.is_action_pressed("ui_up"):
		tilt_dir = 1
	elif Input.is_action_pressed("ui_down"):
		tilt_dir = -1
	
	var desired_speed := direction * speed
	var speed_difference := desired_speed - velocity.x
	var speed_adjust = speed_factor * delta
	if speed_adjust > 1.0:
		speed_adjust = 1.0
	velocity.x += speed_difference * speed_adjust
	position.x += velocity.x * delta
	position.x = clamp(position.x, width * 0.5, VIEWPORT_WIDTH - (width * 0.5) )  # Keep it inside screen 
	
	rotation += tilt_dir * tilt_amount
	rotation = clamp(rotation, -MAX_TILT, MAX_TILT)
	
	
func _handle_wider_paddle(time: float):
	if (%PowerupTimer.time_left > 0.0):
		var new_time = %PowerupTimer.time_left + POWER_UP_S
		%PowerupTimer.stop()
		%LabelUpdateTimer.stop()
		%PowerupTimer.start(new_time)
		%LabelUpdateTimer.start(0.1)
		%PowerupLabel.text = _get_powerup_time_left()
	else:
		paddle_sprite.scale.x *= 2.0
		$CollisionShape2D.scale.y *= 2.0
		width = width * 2
		%PowerupTimer.start(time)
		%LabelUpdateTimer.start(0.1)
		%PowerupLabel.text = _get_powerup_time_left()
		%PowerupLabel.visible = true
				
func reset_paddle_size():
	pass

func _get_powerup_time_left():
	return str(int(%PowerupTimer.time_left))
		
func _on_level_ready():
	var paddle_powerups = get_tree().get_nodes_in_group("Paddle_Powerup")
	for member in paddle_powerups:
		member.paddle_powerup_hit.connect(_handle_wider_paddle)
	var bricks = get_tree().get_nodes_in_group("Brick")
	for member in bricks:
		member.level_beaten.connect(_on_level_beaten)

func _on_level_beaten():
	GameManager.paddle_powerup_time_left = %PowerupTimer.time_left
	%PowerupTimer.set_paused(true)
	%LabelUpdateTimer.set_paused(true)

func _on_powerup_timer_timeout() -> void:
		paddle_sprite.scale.x *= 0.5
		$CollisionShape2D.scale.y *= 0.5
		width = width * 0.5 # TODO: is this necessary?
		%PowerupTimer.stop()
		%LabelUpdateTimer.stop()
		%PowerupLabel.visible = false

func _on_label_update_timer_timeout() -> void:
	if %PowerupTimer != null && %PowerupLabel != null:
		%PowerupLabel.text = _get_powerup_time_left()

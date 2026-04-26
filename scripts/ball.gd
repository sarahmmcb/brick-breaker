extends CharacterBody2D

var speed := 300.0
var dir := Vector2.DOWN
var is_active := true

func _ready() -> void:
	speed = speed + (20 * GameManager.level)
	velocity = Vector2(speed * -1, speed)
	
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
		if abs(velocity.x) < 10:
			velocity.x = -200
	

func game_over():
	GameManager.score = 0
	get_tree().reload_current_scene()
	

func _on_death_zone_body_entered(_body: Node2D) -> void:
	call_deferred("game_over")

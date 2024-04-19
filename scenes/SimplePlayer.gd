extends Sprite2D

const SPEED : int = 400

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("right"):		
		position.x += SPEED * delta
	elif Input.is_action_pressed("left"):
		position.x -= SPEED * delta
	if Input.is_action_pressed("down"):
		position.y += SPEED * delta
	elif Input.is_action_pressed("up"):
		position.y -= SPEED * delta

	

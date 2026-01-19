extends Camera2D

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("right"):
		position.x = position.x + 5
	elif Input.is_action_pressed("left"):
		position.x = position.x - 5

extends Node3D

func _physics_process(delta: float) -> void:
	var input_hor = Input.get_axis("stick2_left","stick2_right")
	rotate_y(input_hor/10)
	if Input.is_action_pressed("break"):
		rotation.y = 0

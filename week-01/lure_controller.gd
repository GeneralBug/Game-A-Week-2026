extends CharacterBody3D

var steering_h: float
var steering_v: float
var speed = 0.0
@export var acceleration = 1
@export var drag = 1
@export var max_speed = 10

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("accelerate"):
		speed += acceleration
	else:
		speed -= drag
	speed = clampf(speed, 0.0, max_speed)
	steering_h = Input.get_axis("stick_left", "stick_right") 
	steering_v = Input.get_axis("stick_up", "stick_down")
	
	rotate_object_local(Vector3(0, 1, 0), clamp(steering_h, deg_to_rad(-2), deg_to_rad(2)))
	rotate_object_local(Vector3(1, 0, 0), clamp(steering_v, deg_to_rad(-1), deg_to_rad(1)))
	transform = transform.orthonormalized()
	self.velocity = transform.basis.z * speed
	self.move_and_slide()

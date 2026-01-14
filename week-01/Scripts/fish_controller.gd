#based on https://github.com/Chevifier/ChevifierTutorials/blob/main/PlaneController/Scenes/PlaneController.gd
extends CharacterBody3D

@export var MAX_SPEED := 80.0 #meters per second
@export var MIN_SPEED := 0.0
@export var acceleration := 15.5
@export var drag := 10.5

@export var yaw_speed := 45.0 #degrees per second
@export var pitch_speed := 45.0
@export var roll_speed := 45.0

var speed = 0.0
var turn_input =  Vector2()

@export var anim: AnimationPlayer


func _ready() -> void:
	pitch_speed = deg_to_rad(pitch_speed)
	yaw_speed = deg_to_rad(yaw_speed)
	roll_speed = deg_to_rad(roll_speed)

func _physics_process(delta: float) -> void:
	var input_hor = Input.get_axis("stick_left","stick_right")
	var input_ver = Input.get_axis("stick_up","stick_down")
	turn_input = Vector2(input_hor, input_ver)
	

	if Input.is_action_pressed("accelerate"):
		speed += acceleration
	else:
		speed -= drag
	animate_tail(speed, input_hor, input_ver)
	speed = clampf(speed, MIN_SPEED, MAX_SPEED)
	velocity = basis.z * speed
	move_and_slide()
	var turn_dir = Vector3(-turn_input.y,-turn_input.x, 0)
	apply_rotation(turn_dir,delta)
	turn_input = Vector2()


func apply_rotation(vector,delta):
	rotate(basis.z,vector.z * roll_speed * delta)
	rotate(basis.x,vector.x * pitch_speed * delta)
	rotate(basis.y,vector.y * yaw_speed * delta)
	#lean mesh
	if vector.y < 0:
		self.rotation.z = lerp_angle(self.rotation.z, deg_to_rad(-45)*vector.y,delta)
	elif vector.y > 0:
		self.rotation.z = lerp_angle(self.rotation.z, deg_to_rad(45)*-vector.y,delta)
	else:
		self.rotation.z = lerp_angle(self.rotation.z, 0,delta)

func animate_tail(speed, rotation1, rotation2):
	anim.play("tail", -1, clamp(speed/2 + abs(rotation1)*5 + abs(rotation2)*5, MIN_SPEED + 0.1, MAX_SPEED/2), false)

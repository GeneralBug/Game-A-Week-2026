extends Node2D

@export var speed = 1.0
@export var max_speed = 10000.0
@export var ball : RigidBody2D
var charging = false
var launched = false
var ball_speed = 0.0
@export var dog : Node2D
@export var camera : Node2D
@export var label : RichTextLabel
var score = 0

func _physics_process(delta: float) -> void:
	if !launched:
		if !charging:
			if Input.is_action_pressed("charge"):
				charging = true
		
		if charging:
			if !Input.is_action_pressed("charge"):
				label.text = ""
				ball.freeze = false
				ball.apply_impulse(Vector2(rotation_to_direction(rotation) * ball_speed))
				charging = false
				launched = true
				ball.reparent($"..", true)
				#ball = $"../BALL!"
				dog.speed = 10
				dog.chasing = true
				camera.active = true
				print(ball_speed)
			else:
				ball_speed = clamp(ball_speed + speed, 0, max_speed)
	else:
		ball_speed = clamp(ball_speed - (speed*2), 0, max_speed)
	rotation = lerp(rotation, rotation + ball_speed/100, delta)

#https://old.reddit.com/r/godot/comments/gh46hy/is_there_a_way_to_convert_an_angle_to_vector2/mdzadym/
func rotation_to_direction(angle: float) -> Vector2:
	# Calculate direction vector
	var direction = Vector2(cos(angle), sin(angle))
	# Normalize the vector (optional, but ensures length = 1)
	direction = direction.normalized()
	return direction
	
func freeze_ball():
	ball.freeze = true
	ball.global_position = $"../DOG!/Mouth Pivot".global_position

func _on_dog_body_entered(body: Node2D) -> void:
	if body.name == "BALL!":
		dog.chasing = false
		call_deferred("freeze_ball")
		print("caught ", body.name)
		score = snapped(abs(dog.position.x / 100), 0.01)
		label.text = str(score, "m! Good boy :)")

func _on_bondary_body_entered(body: Node2D) -> void:
	print(body, " touched boundary!")
	if body.name == "BALL!":
		#print out of bounds message
		pass

func _on_area_2d_area_entered(area: Area2D) -> void:
	print(area, " touched boundary!")
	if area.name == "DOG!":
		dog.chasing = false
		label.text = str("Over the fence :(")

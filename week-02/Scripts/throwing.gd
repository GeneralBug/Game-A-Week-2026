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
@export var label_reset : RichTextLabel
@export var voice : AudioStreamPlayer
@export var voicelines : Array[AudioStream]
var score = 0
var reset_prompt = false
var reset_timer = 0
var ball_out = false
var dog_out = false

func _physics_process(delta: float) -> void:
	if ball_out && dog_out:
		out_of_bounds()
		ball_out = false
		dog_out = false
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
				voice.stream = voicelines[0]
				voice.play()
			else:
				ball_speed = clamp(ball_speed + speed, 0, max_speed)
	else:
		ball_speed = clamp(ball_speed - (speed*2), 0, max_speed)
	rotation = lerp(rotation, rotation + ball_speed/100 , delta)
	if reset_prompt:
		reset_timer += delta
	if reset_timer >= 5:
		label_reset.visible = true
		

#https://old.reddit.com/r/godot/comments/gh46hy/is_there_a_way_to_convert_an_angle_to_vector2/mdzadym/
func rotation_to_direction(angle: float) -> Vector2:
	# Calculate direction vector
	var direction = Vector2(cos(angle), sin(angle))
	# Normalize the vector (optional, but ensures length = 1)
	direction = direction.normalized()
	return direction
	
func freeze_ball():
	ball.freeze = true
	ball.global_position =$"../DOG!/Mouth Pivot".global_position

func _on_dog_body_entered(body: Node2D) -> void:
	if body.name == "BALL!":
		dog.chasing = false
		call_deferred("freeze_ball")
		print("caught ", body.name)
		score = snapped(abs(dog.position.x / 100), 0.01)
		label.text = str(score, "m! Good boy :)")
		voice.stream = voicelines[1]
		voice.play()
		reset_prompt = true

func _on_boundary_area_entered(area: Area2D) -> void:
	print(area, " touched boundary!")
	if area.name == "DOG!":
		dog_out = true
		
func _on_boundary_body_entered(body: Node2D) -> void:
	print(body, " touched boundary!")
	if body == ball:
		ball_out = true

func _on_boundary_body_exited(body: Node2D) -> void:
	print(body, " touched boundary!")
	if body == ball:
		ball_out = false

func out_of_bounds():
	dog.chasing = false
	label.text = str("Over the fence :(")
	voice.stream = voicelines[2]
	voice.play()
	reset_prompt = true

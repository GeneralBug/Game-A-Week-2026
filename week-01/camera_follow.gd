extends Node3D

@export var follow_target: Node3D
@export var look_target: Node3D
@export var speed = 1
@export var flip: bool

func _physics_process(delta: float) -> void:
	global_position = lerp(global_position, follow_target.global_position, delta * speed)
	if flip:
		look_at(look_target.position * -1)
	else:
		look_at(look_target.position)

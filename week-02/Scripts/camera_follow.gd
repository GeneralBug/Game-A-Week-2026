extends Node2D

@export var follow_target: Node2D
@export var active = true

func _physics_process(delta: float) -> void:
	if active:
		global_position.x = follow_target.global_position.x

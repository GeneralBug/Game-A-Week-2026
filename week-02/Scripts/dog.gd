extends Area2D

@export var chasing = false
@export var sprite : AnimatedSprite2D
@export var follow_target : Node2D
@export var speed = 0


func _physics_process(delta: float) -> void:
	if chasing:
		if sprite.animation != "running":
			sprite.play("running")
		global_position.x = lerp(global_position.x, follow_target.global_position.x, delta * speed)
	if !chasing && sprite.animation != "idle":
		sprite.play("idle")
		$CollisionShape2D.disabled = true

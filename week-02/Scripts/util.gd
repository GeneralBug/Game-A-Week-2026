extends Node

var resetables = preload("res://Scene/resetables.tscn")
var instance : Node2D

func _ready() -> void:
	instance = resetables.instantiate()
	self.add_child(instance)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fullscreen"):
		var mode := DisplayServer.window_get_mode()
		print(mode)
		if mode == DisplayServer.WINDOW_MODE_FULLSCREEN || mode == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	elif event.is_action_pressed("reset"):
		instance.queue_free()
		instance = resetables.instantiate()
		self.add_child(instance)
	elif event.is_action_pressed("quit"):
		#get_tree().quit()
		#quit button breaks on web version
		pass

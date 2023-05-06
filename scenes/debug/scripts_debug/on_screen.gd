extends Node

@export var character_body: CharacterBody2D

func _on_screen_exited() -> void:
	character_body.queue_free()

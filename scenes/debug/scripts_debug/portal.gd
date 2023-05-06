extends Area2D

@export var next_scene: String
@export var character_body: CharacterBody2D

func _on_body_entered(body):
	if body.is_in_group("player"):
		pass
		

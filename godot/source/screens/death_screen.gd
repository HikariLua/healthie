class_name DeathScreen
extends CanvasLayer


func _ready() -> void:
	TransitionScreenAutoload.connect("transition_complete", self_destroy)


func show_lifes() -> void:
	pass


func self_destroy() -> void:
	queue_free()

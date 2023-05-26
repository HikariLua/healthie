extends Node

var pause_screen: PackedScene = preload(
	"res://scenes/screens/pause_screen.tscn"
)

var pause_reference: CanvasLayer

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if get_tree().paused:
			get_tree().paused = false
			pause_reference.queue_free()

		else:
			get_tree().paused = true
			
			pause_reference = pause_screen.instantiate()
			get_tree().get_root().add_child(pause_reference)

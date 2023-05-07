extends Node

var pause_screen: CanvasLayer = preload(
	"res://scenes/screens/pause_screen.tscn"
).instantiate()


func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if get_tree().paused:
			get_tree().paused = false
			pause_screen.queue_free()
			
			pause_screen = preload(
				"res://scenes/screens/pause_screen.tscn"
			).instantiate()
		else:
			get_tree().paused = true
			get_tree().get_root().add_child(pause_screen)

extends Button


func _on_pressed() -> void:
	get_tree().paused = false
	
	GlobalCommands.pause_screen = preload(
		"res://scenes/screens/pause_screen.tscn"
	).instantiate()
	
	owner.queue_free()

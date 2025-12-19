class_name PauseComponent
extends Node

var pause_screen_packed: PackedScene = preload(
	"res://scenes/screens/pause_screen.tscn"
)

var pause_screen: PauseScreen


func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		toggle_pause()


func toggle_pause() -> void:
	if get_tree().paused:
		get_tree().paused = false

		pause_screen.queue_free()

	else:
		get_tree().paused = true

		pause_screen = pause_screen_packed.instantiate()
		get_tree().get_root().add_child(pause_screen)

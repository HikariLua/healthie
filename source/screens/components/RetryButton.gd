extends Button

@export var animation_player: AnimationPlayer
@export var blocker: ColorRect


func _ready() -> void:
	TransitionScreen.connect("fade_outed", reload)


func _on_pressed() -> void:
	blocker.visible = true
	TransitionScreen.animation_player.play("fade_out")
	animation_player.play("fade")


func reload() -> void:
	get_tree().reload_current_scene()
	get_tree().paused = false
	
	GlobalCommands.pause_screen = preload(
		"res://scenes/screens/pause_screen.tscn"
	).instantiate()
	
	owner.queue_free()

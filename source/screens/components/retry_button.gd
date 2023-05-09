extends Button

@export var animation_player: AnimationPlayer
@export var blocker: ColorRect


func _ready() -> void:
	TransitionScreen.connect("fade_outed", reload)


func _on_pressed() -> void:
	blocker.visible = true
	TransitionScreen.transition_to("res://scenes/screens/main_menu.tscn", get_tree())
	animation_player.play("fade")



func reload() -> void:
	get_tree().reload_current_scene()
	get_tree().paused = false
	
	GlobalCommands.pause_screen = preload(
		"res://scenes/screens/pause_screen.tscn"
	).instantiate()
	
	owner.queue_free()

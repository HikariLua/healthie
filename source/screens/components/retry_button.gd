extends Button

@export var animation_player: AnimationPlayer
@export var blocker: ColorRect

@export var select_sfx: AudioStreamPlayer
@export var click_sfx: AudioStreamPlayer
@export var first_button: bool = false


func _ready() -> void:
	TransitionScreen.connect("fade_outed", reload)
	if first_button:
		grab_focus()


func _on_pressed() -> void:
	blocker.visible = true
	TransitionScreen.transition_to(
		"res://scenes/screens/main_menu.tscn", get_tree()
	)
	animation_player.play("fade")


func reload() -> void:
	get_tree().reload_current_scene()
	get_tree().paused = false

	owner.queue_free()


func _on_mouse_entered() -> void:
	select_sfx.play()


func _on_button_down() -> void:
	click_sfx.play()

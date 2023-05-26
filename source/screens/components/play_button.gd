extends Button

@export var select_sfx: AudioStreamPlayer
@export var click_sfx: AudioStreamPlayer
@export var start_focus: bool = false

var main_scene: PackedScene = preload("res://scenes/levels/level_0.tscn")


func _ready() -> void:
	grab_focus()


func _on_pressed() -> void:
	PlayerInfo.lifes = 3
	PlayerInfo.current_level = 0
	TransitionScreen.transition_to_packed(main_scene, get_tree())


func _on_mouse_entered() -> void:
	select_sfx.play()


func _on_button_down() -> void:
	click_sfx.play()

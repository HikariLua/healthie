extends Button

@export var select_sfx: AudioStreamPlayer
@export var click_sfx: AudioStreamPlayer
@export var start_focus: bool = false

var main_scene: PackedScene = preload("uid://kk2jle7s538x")


func _ready() -> void:
	grab_focus()


func _on_pressed() -> void:
	SaveLoadAutoload.save_to_next_scene("player", {"lifes": 3})
	TransitionScreenAutoload.transition_to_packed(main_scene, get_tree())


func _on_mouse_entered() -> void:
	select_sfx.play()


func _on_button_down() -> void:
	click_sfx.play()

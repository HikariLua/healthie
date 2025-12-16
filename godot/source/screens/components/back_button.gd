extends Button

@export var select_sfx: AudioStreamPlayer
@export var click_sfx: AudioStreamPlayer
@export var to_scene: String


func _ready() -> void:
	grab_focus()


func _on_pressed() -> void:
	TransitionScreen.transition_to(to_scene, get_tree())


func _on_mouse_entered() -> void:
	select_sfx.play()


func _on_button_down() -> void:
	click_sfx.play()

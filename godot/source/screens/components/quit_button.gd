extends Button

@export var select_sfx: AudioStreamPlayer
@export var click_sfx: AudioStreamPlayer


func _on_pressed() -> void:
	get_tree().quit()


func _on_mouse_entered() -> void:
	select_sfx.play()


func _on_button_down() -> void:
	click_sfx.play()

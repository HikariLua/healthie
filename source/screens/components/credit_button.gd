extends Button

@export var select_sfx: AudioStreamPlayer2D
@export var click_sfx: AudioStreamPlayer2D

var credits_scene: PackedScene = preload(
	"res://scenes/screens/credit_screen.tscn"
)


func _on_pressed() -> void:
	TransitionScreen.transition_to_packed(credits_scene, get_tree())


func _on_mouse_entered() -> void:
	select_sfx.play()


func _on_button_down() -> void:
	click_sfx.play()

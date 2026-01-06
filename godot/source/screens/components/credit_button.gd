extends Button

@export var select_sfx: AudioStreamPlayer
@export var click_sfx: AudioStreamPlayer

var credits_scene: PackedScene = preload(
	"uid://7xafqjp8h31s"
)


func _on_pressed() -> void:
	TransitionScreenAutoload.transition_to_packed(credits_scene, get_tree())


func _on_mouse_entered() -> void:
	select_sfx.play()


func _on_button_down() -> void:
	click_sfx.play()

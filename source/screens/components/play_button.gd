extends Button

@export var select_sfx: AudioStreamPlayer2D
@export var click_sfx: AudioStreamPlayer2D


var main_scene: PackedScene = preload(
	"res://scenes/levels/level_1.tscn"
)


func _on_pressed() -> void:
	PlayerInfo.lifes = 1
	PlayerInfo.current_level = 1
	get_tree().change_scene_to_packed(main_scene)


func _on_mouse_entered() -> void:
	select_sfx.play()


func _on_button_down() -> void:
	click_sfx.play()

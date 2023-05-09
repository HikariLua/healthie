extends Button

var main_scene: PackedScene = preload(
	"res://scenes/levels/level_1.tscn"
)


func _on_pressed() -> void:
	PlayerInfo.lifes = 1
	PlayerInfo.current_level = 1
	get_tree().change_scene_to_packed(main_scene)

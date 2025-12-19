extends CanvasLayer


func _ready() -> void:
	Music.play(Music.game_over)

	SaveLoad.saved_dict.clear()

extends CanvasLayer

func _ready() -> void:
	MusicAutoload.play(MusicAutoload.music_list[3])

	SaveLoadAutoload.saved_dict.clear()

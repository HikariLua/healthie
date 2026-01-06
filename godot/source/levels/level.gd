extends Node2D

@export var music_index: int

func _ready() -> void:
	MusicAutoload.play(MusicAutoload.music_list[music_index])

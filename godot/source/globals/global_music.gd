extends Node

@export var menu: AudioStreamPlayer
@export var level_1: AudioStreamPlayer
@export var level_2: AudioStreamPlayer
@export var level_3: AudioStreamPlayer
@export var game_over: AudioStreamPlayer
@export var win: AudioStreamPlayer

@onready var music_list: Array[AudioStreamPlayer] = [
	menu,
	level_1,
	level_2,
	level_3,
	game_over,
	win
]

func play(music: AudioStreamPlayer) -> void:
	if music.playing:
		return
	
	for item in music_list:
		if item == music:
			continue
		
		item.stop()
	
	music.play()

extends Node

var saved_dict: Dictionary = {}


func save_to_next_scene(key: String, dict: Dictionary) -> void:
	saved_dict[key] = dict


func load_from_previous_scene(key: String) -> Dictionary:
	var load_value: Dictionary = saved_dict[key]

	return load_value

class_name PauseScreen
extends CanvasLayer

@export var focus_on_show_button: Button


func _ready() -> void:
	assert(focus_on_show_button != null)
	focus_on_show_button.grab_focus()

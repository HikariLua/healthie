extends CanvasLayer

@export var requierd: Label
@export var final: Label
@export var result: Label
@export var plus: Label


func _enter_tree() -> void:
	await get_tree().create_timer(6).timeout
	queue_free()

class_name JunkFood
extends Area2D


@export var is_random := true
@export var sprite: Sprite2D

@onready var max_frames: int = sprite.hframes * sprite.vframes


func _ready() -> void:
	self.area_entered.connect(_on_area_2d_entered)

	if is_random:
		sprite.frame = randi_range(0, max_frames - 1)


func _on_area_2d_entered(_area: Area2D) -> void:
	self_destroy()


func self_destroy() -> void:
	queue_free()

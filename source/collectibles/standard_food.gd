class_name StandardFood
extends CharacterBody2D

@export var sprite: Sprite2D
@export var is_random := true

@export var speed: float = 0
@export var direction := Vector2.ZERO

@onready var max_frames: int = sprite.hframes * sprite.vframes


func _ready() -> void:
	velocity = direction * speed
	if is_random:
		sprite.frame = randi_range(0, max_frames - 1)


func _physics_process(_delta: float) -> void:
	if (is_on_wall() or is_on_floor() or is_on_ceiling()) and not speed == 0:
		self_destroy()
	
	move_and_slide()


func _on_area_2d_area_entered(_area: Area2D) -> void:
	self_destroy()


func self_destroy() -> void:
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if not speed == 0:
		self_destroy()

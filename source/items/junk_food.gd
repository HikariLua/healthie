class_name StandardFood
extends CharacterBody2D

@export var sprite: Sprite2D
@export var is_random := true

@export var speed: float = 0
@export var direction := Vector2.ZERO
@export var body_collision: CollisionShape2D

@onready var max_frames: int = sprite.hframes * sprite.vframes

var timer: Timer = Timer.new()


func _ready() -> void:
	add_child(timer)
	timer.one_shot = true
	timer.connect("timeout", self_destroy)

	velocity = direction * speed
	if is_random:
		sprite.frame = randi_range(0, max_frames - 1)

	if speed == 0:
		self.set_physics_process(false)
		body_collision.set_deferred("desabled", true)

	else:
		timer.start(10)


func _physics_process(_delta: float) -> void:
	if is_on_wall() or is_on_floor() or is_on_ceiling():
		self_destroy()

	move_and_slide()


func _on_area_2d_area_entered(_area: Area2D) -> void:
	self_destroy()


func self_destroy() -> void:
	timer.stop()
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if not speed == 0:
		self_destroy()

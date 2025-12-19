class_name JunkFood
extends Area2D


@export var is_random := true

# TODO: refatorar logica de projetil junk food
@export var speed: float = 0
@export var direction := Vector2.ZERO

@export var timer: Timer
@export var sprite: Sprite2D
@export var visible_notifier: VisibleOnScreenNotifier2D

@onready var max_frames: int = sprite.hframes * sprite.vframes


func _ready() -> void:
	timer.timeout.connect(self_destroy)
	visible_notifier.screen_exited.connect(_on_visible_on_screen_notifier_2d_screen_exited)
	self.area_entered.connect(_on_area_2d_entered)


	if is_random:
		sprite.frame = randi_range(0, max_frames - 1)

	if speed == 0:
		self.set_physics_process(false)

	else:
		timer.start(10)


func _physics_process(delta: float) -> void:
	position += (direction * speed) * delta

	if has_overlapping_bodies():
		var bodies: Array[Node2D] = get_overlapping_bodies()
		check_cannon(bodies)


func check_cannon(bodies: Array[Node2D]) -> void:
	for body in bodies:
		if not body.is_in_group("cannon"):
			self_destroy()
			return


func _on_area_2d_entered(_area: Area2D) -> void:
	self_destroy()


func self_destroy() -> void:
	timer.stop()
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if not speed == 0:
		self_destroy()

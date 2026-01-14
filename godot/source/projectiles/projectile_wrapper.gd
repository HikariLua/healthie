class_name ProjectileWrapper
extends Node2D


@export var speed: float = 0
@export var direction := Vector2.ZERO
@export var projectile_area: Area2D

@export var timer: Timer
@export var visible_notifier: VisibleOnScreenNotifier2D


func _ready() -> void:
	timer.timeout.connect(self_destroy)
	visible_notifier.screen_exited.connect(_on_visible_on_screen_notifier_2d_screen_exited)
	projectile_area.area_entered.connect(_on_area_2d_entered)

	timer.start(10)


func _physics_process(delta: float) -> void:
	position += (direction * speed) * delta

	if projectile_area.has_overlapping_bodies():
		var bodies: Array[Node2D] = projectile_area.get_overlapping_bodies()
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
	self_destroy()

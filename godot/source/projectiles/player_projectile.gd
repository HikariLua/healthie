class_name PlayerProjectile
extends Area2D

@export var speed: int = 200
@export var hitbox: AttackHitbox

var direction := Vector2.RIGHT
var damage: int = 1


func _ready() -> void:
	global_position.y -= 7.5
	
	hitbox.damage = self.damage


func _enter_tree() -> void:
	var color: Color = Color8(
		randi_range(80, 255),
		randi_range(80, 255),
		randi_range(80, 255)
	)
	
	modulate = color


func _physics_process(delta: float) -> void:
	position += (direction * speed) * delta
	
	if has_overlapping_bodies():
		self_destroy()


func self_destroy() -> void:
	queue_free()


func _on_hitbox_area_entered(_area: Area2D) -> void:
	self_destroy()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	self_destroy()

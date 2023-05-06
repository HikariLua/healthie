class_name PlayerProjectile
extends CharacterBody2D

@export var speed: int = 200
@export var hitbox: AttackHitbox

var direction := Vector2.RIGHT
var damage: int = 1


func _ready() -> void:
	global_position.y -= 7.5
	velocity = direction * speed
	
	hitbox.damage = self.damage


func _physics_process(_delta: float) -> void:
	if is_on_wall():
		self_destroy()
	
	move_and_slide()


func self_destroy() -> void:
	queue_free()


func _on_hitbox_area_entered(_area: Area2D) -> void:
	self_destroy()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	self_destroy()

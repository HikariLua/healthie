class_name PlayerStateDie
extends State

@export var character_body: CharacterBody2D
@export var motion: MotionComponent
@export var hurtbox_collision: CollisionShape2D


func _ready() -> void:
	assert(character_body != null)


func on_enter(_message := {}) -> void:
	hurtbox_collision.set_deferred("disabled", true)
	animation_player.play("die")

	character_body.velocity.x = 0


func physics_update(delta: float) -> void:
	character_body.velocity.y = motion.apply_gravity(character_body, delta)

	character_body.move_and_slide()

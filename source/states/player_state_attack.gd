class_name PlayerStateAttack
extends State

@export var character_body: CharacterBody2D

@export var motion: MotionComponent

@export var umbrella_sprite: Sprite2D
@export var hitbox_collision: CollisionShape2D


func _ready() -> void:
	assert(character_body != null)
	assert(motion != null)
	assert(umbrella_sprite != null)
	assert(hitbox_collision != null)


func on_enter(_message := {}) -> void:
	umbrella_sprite.visible = true
	motion.two_direction_animation(animation_player, "attack")

	character_body.velocity.x = 0


func physics_update(delta: float) -> void:
	character_body.velocity.y = motion.apply_gravity(character_body, delta)
	
	character_body.move_and_slide()
	

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if not anim_name.begins_with("attack"):
		return
	
	state_machine.transition_state_to("PlayerStateIdle")


func on_exit() -> void:
	umbrella_sprite.visible = false
	hitbox_collision.set_deferred("disabled", true)

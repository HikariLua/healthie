class_name PlayerStateAttack
extends State

@export var character_body: CharacterBody2D
@export var attack_sfx: AudioStreamPlayer2D

@export var motion: MotionComponent


func _ready() -> void:
	assert(character_body != null)
	assert(motion != null)


func on_enter(_message := {}) -> void:
	var projectile: PlayerProjectile = preload(
		"res://scenes/projectiles/player_projectile.tscn"
	).instantiate()

	projectile.global_position = character_body.global_position
	projectile.global_position.y -= 7.5
	projectile.direction.x = motion.looking_direction.x

	get_tree().get_root().add_child(projectile)

	motion.two_direction_animation(animation_player, "attack")
	attack_sfx.play()

	character_body.velocity.x = 0
	character_body.velocity.y = 0


func physics_update(delta: float) -> void:
	character_body.velocity.y = motion.apply_gravity(character_body, delta)
	
	character_body.move_and_slide()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if not state_machine.active_state == self:
		return
	if not anim_name.begins_with("attack"):
		return
	
	state_machine.transition_state_to("PlayerStateIdle")

class_name EnemyStateDie01
extends State

@export var character_body: CharacterBody2D
@export var health: HealthComponent

@export var hurt_sfx: AudioStreamPlayer2D
@export var die_sfx: AudioStreamPlayer2D

@export var hurtbox_collision: CollisionShape2D


func _ready() -> void:
	assert(character_body != null)
	assert(health != null)


func _on_health_component_damage_taken(_previous_hp, _attacker_hitbox) -> void:
	hurt_sfx.play()
	
	if health.health_points <= 0:
		state_machine.transition_state_to("EnemyStateDie01")


func on_enter(_message := {}) -> void:
	hurtbox_collision.set_deferred("disabled", true)
	die_sfx.play()
	animation_player.play("die")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if not state_machine.active_state == self:
		return
	if not anim_name == "die":
		return
	
	character_body.queue_free()

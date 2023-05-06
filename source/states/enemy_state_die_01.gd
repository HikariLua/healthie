class_name EnemyStateDie01
extends State

@export var character_body: CharacterBody2D
@export var health: HealthComponent


func _ready() -> void:
	assert(character_body != null)
	assert(health != null)


func _on_health_component_damage_taken(_previous_hp, _attacker_hitbox) -> void:
	if health.health_points <= 0:
		state_machine.transition_state_to("EnemyStateDie01")


func on_enter(_message := {}) -> void:
	character_body.queue_free()

class_name EnemyStateDie01
extends State

@export_group("Nodes")
@export var character_body: CharacterBody2D
@export var hurt_sfx: AudioStreamPlayer2D
@export var die_sfx: AudioStreamPlayer2D
@export var hurtbox_collision: CollisionShape2D
@export var hitbox_collision: CollisionShape2D
@export var effect_player: AnimationPlayer
@export var animation_player: AnimationPlayer
@export var state_machine: StateMachine

@export_group("Components")
@export var health: HealthComponent

@export_group("States")
@export var death_state: EnemyStateDie01


func _ready() -> void:
	assert(character_body != null)
	assert(health != null)
	
	health.damage_taken.connect(_on_health_component_damage_taken)
	animation_player.animation_finished.connect(_on_animation_player_animation_finished)


func _on_enter() -> void:
	hurtbox_collision.set_deferred("disabled", true)
	hitbox_collision.set_deferred("disabled", true)
	die_sfx.play()
	animation_player.play("die")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
#	if not state_machine.active_state == self:
#		return
	if not anim_name == "die":
		return
	
	character_body.queue_free()


func _on_health_component_damage_taken(_previous_hp: int, _attacker_hitbox: Area2D) -> void:
	effect_player.play("hurt")
	hurt_sfx.play()
	
	if health.health_points <= 0:
		state_machine.transition_state(death_state)

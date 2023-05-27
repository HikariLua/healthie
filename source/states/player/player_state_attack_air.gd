class_name PlayerStateAttackAir
extends State

@export var character_body: CharacterBody2D
@export var attack_sfx: AudioStreamPlayer2D

@export var motion: MotionComponent
@export var combat: CombatComponent

var projectile_scene: PackedScene = preload(
	"res://scenes/projectiles/player_projectile.tscn"
)


func _ready() -> void:
	assert(character_body != null)
	assert(motion != null)


func on_enter(_message := {}) -> void:
	var projectile: PlayerProjectile = projectile_scene.instantiate()

	projectile.global_position = character_body.global_position
	projectile.direction.x = motion.looking_direction.x
	projectile.damage = combat.attack_damage

	get_tree().get_root().add_child(projectile)

	motion.two_direction_animation(animation_player, "attack")
	attack_sfx.play()


func physics_update(delta: float) -> void:
	motion.input_direction = motion.update_input_direction()

	motion.looking_direction = motion.set_looking_direction(
		motion.input_direction
	)

	character_body.velocity.x = motion.move_x(
		motion.max_speed, motion.input_direction.x
	)

	if character_body.is_on_floor():
		character_body.velocity.x = 0

	var divisor: float = 1 if character_body.velocity.y <= 0 else 2
	character_body.velocity.y = motion.apply_gravity(
		character_body, delta / divisor
	)

	character_body.move_and_slide()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if not state_machine.active_state == self:
		return
	if not anim_name.begins_with("attack"):
		return

	if not motion.input_direction.x == 0 and not character_body.is_on_floor():
		state_machine.transition_state_to("PlayerStateFall")
		return

	state_machine.transition_state_to("PlayerStateIdle")

class_name PlayerStateAttackAir
extends State

@export_group("Nodes")
@export var character_body: CharacterBody2D
@export var animation_player: AnimationPlayer
@export var state_machine: StateMachine
@export var attack_sfx: AudioStreamPlayer2D

@export_group("Components")
@export var motion: MotionComponent
@export var combat: CombatComponent

@export_group("States")
@export var idle_state: PlayerStateIdle
@export var fall_state: PlayerStateFall

var projectile_scene: PackedScene = preload("uid://7vtkxafog8wi")


func _ready() -> void:
	assert(character_body != null)
	assert(animation_player != null)
	assert(state_machine != null)
	assert(motion != null)
	assert(combat != null)
	assert(idle_state != null)

	animation_player.animation_finished.connect(_on_animation_player_animation_finished)


func _on_enter() -> void:
	var projectile: PlayerProjectile = projectile_scene.instantiate()

	projectile.global_position = character_body.global_position
	projectile.direction.x = motion.looking_direction.x
	projectile.damage = combat.attack_damage

	get_tree().get_root().add_child(projectile)

	MotionComponent.two_direction_animation(
		animation_player,
		motion.looking_direction.x,
		"attack"
	)

	attack_sfx.play()


func _physics_update(delta: float) -> void:
	motion.input_direction = MotionComponent.update_input_direction()

	motion.looking_direction = motion.input_direction

	character_body.velocity.x = 0

	motion.looking_direction = motion.input_direction

	character_body.velocity.x = MotionComponent.move_x(
		motion.max_speed,
		motion.input_direction.x
	)

	if character_body.is_on_floor():
		character_body.velocity.x = 0

	var divisor: float = 1 if character_body.velocity.y <= 0 else 2
	character_body.velocity.y = MotionComponent.apply_gravity(
		character_body,
		motion.max_fall_speed,
		motion.gravity,
		delta / divisor
	)

	character_body.move_and_slide()


func should_fall() -> bool:
	return motion.input_direction.x != 0 and not character_body.is_on_floor()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if not state_machine.active_state == self:
		return
	if not anim_name.begins_with("attack"):
		return

	if should_fall():
		state_machine.transition_state(fall_state)
		return

	state_machine.transition_state(idle_state)

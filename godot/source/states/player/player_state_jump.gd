class_name PlayerStateJump
extends State

## Jump state executed when the player is on floor
@export_group("Nodes")
@export var character_body: CharacterBody2D
@export var animation_player: AnimationPlayer
@export var state_machine: StateMachine
@export var jump_sfx: AudioStreamPlayer2D

@export_group("Components")
@export var motion: MotionComponent

@export_group("States")
@export var fall_state: PlayerStateFall
@export var attack_air_state: PlayerStateAttackAir
@export var run_state: PlayerStateRun
@export var idle_state: PlayerStateIdle

@onready var min_jump_velocity: float = motion.jump_velocity / 2


func _ready() -> void:
	assert(character_body != null)
	assert(animation_player != null)
	assert(state_machine != null)
	assert(jump_sfx != null)
	assert(motion != null)
	assert(fall_state != null)
	assert(run_state != null)
	assert(idle_state != null)
	assert(attack_air_state != null)

	transitions = {
		attack_air_state: attack_air_transition,
		run_state: run_transition,
		idle_state: idle_transition,
		fall_state: fall_transition
	}


func _on_enter() -> void:
	animation_player.play(MotionComponent.two_direction_animation(
		motion.looking_direction.x,
		"jump"
		)
	)

	character_body.velocity.y = motion.jump_velocity

	jump_sfx.play()


func _physics_update(delta: float) -> void:
	motion.input_direction = MotionComponent.update_input_direction()

	motion.looking_direction = motion.input_direction

	animation_player.play(MotionComponent.two_direction_animation(
		motion.looking_direction.x,
		"jump"
		)
	)

	character_body.velocity.x = MotionComponent.move_x(
		motion.max_speed,
		motion.input_direction.x
	)

	character_body.velocity.y = MotionComponent.apply_gravity(
		character_body,
		motion.max_fall_speed,
		motion.gravity,
		delta
	)

	if Input.is_action_just_released("jump"):
		regulate_jump()

	motion.was_on_floor = character_body.is_on_floor()

	character_body.move_and_slide()


func regulate_jump() -> void:
	if character_body.velocity.y < min_jump_velocity:
		character_body.velocity.y = min_jump_velocity


func attack_air_transition() -> Array[Variant]:
	var condition := Input.is_action_just_pressed("attack")
	return [condition, null]


func run_transition() -> Array[Variant]:
	var condition := character_body.is_on_floor() and motion.input_direction.x != 0
	return [condition, null]


func idle_transition() -> Array[Variant]:
	var condition := character_body.is_on_floor()
	return [condition, null]


func fall_transition() -> Array[Variant]:
	var condition := character_body.velocity.y >= 0

	return [condition, null]

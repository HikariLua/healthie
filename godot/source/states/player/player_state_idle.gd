class_name PlayerStateIdle
extends State

## Idle state executed when player is standing still on ground

@export_group("Nodes")
@export var character_body: CharacterBody2D
@export var animation_player: AnimationPlayer
@export var state_machine: StateMachine

@export_group("Components")
@export var motion: MotionComponent

@export_group("States")
@export var jump_state: PlayerStateJump
@export var fall_state: PlayerStateFall
@export var run_state: PlayerStateRun
@export var attack_state: PlayerStateAttack


func _ready() -> void:
	assert(character_body != null)
	assert(animation_player != null)
	assert(state_machine != null)
	assert(motion != null)
	assert(jump_state != null)
	assert(fall_state != null)
	assert(run_state != null)
	assert(attack_state != null)

	transitions = {
		jump_state: jump_transition,
		fall_state: fall_transition,
		run_state: run_transition,
		attack_state: attack_transition
	}


func _on_enter() -> void:
	animation_player.play(MotionComponent.two_direction_animation(
		motion.looking_direction.x,
		"idle"
		)
	)


func _physics_update(delta: float) -> void:
	motion.input_direction = MotionComponent.update_input_direction()

	motion.looking_direction = motion.input_direction

	character_body.velocity.x = 0

	character_body.velocity.y = MotionComponent.apply_gravity(
		character_body,
		motion.max_fall_speed,
		motion.gravity,
		delta
	)

	motion.was_on_floor = character_body.is_on_floor()
	
	character_body.move_and_slide()

# TODO: fazer lógica de transição padrão
func jump_transition() -> Array[Variant]:
	var condition := (
		Input.is_action_just_pressed("jump")
		and character_body.is_on_floor()
	)

	return [condition, null]


func fall_transition() -> Array[Variant]:
	var condition := character_body.velocity.y > 0
	return [condition, null]


func run_transition() -> Array[Variant]:
	var condition := motion.input_direction.x != 0
	return [condition, null]


func attack_transition() -> Array[Variant]:
	var condition := Input.is_action_just_pressed("attack")
	return [condition, null]

class_name PlayerStateRun
extends State

## Run state executed when player is on floor

@export_group("Nodes")
@export var character_body: CharacterBody2D
@export var animation_player: AnimationPlayer
@export var state_machine: StateMachine

@export_group("Components")
@export var motion: MotionComponent

@export_group("States")
@export var jump_state: PlayerStateJump
@export var fall_state: PlayerStateFall
@export var idle_state: PlayerStateIdle
@export var attack_state: PlayerStateAttack

var speed_divisor: float


func _ready() -> void:
	assert(character_body != null)
	assert(animation_player != null)
	assert(state_machine != null)
	assert(motion != null)
	assert(jump_state != null)
	assert(fall_state != null)
	assert(idle_state != null)
	assert(attack_state != null)

	transitions = {
		jump_state: jump_transition,
		fall_state: fall_transition,
		idle_state: idle_transition,
		attack_state: attack_transition
	}
	
	motion.looking_direction_changed.connect(_on_motion_component_looking_direction_changed)


func _on_enter() -> void:
	animation_player.play(MotionComponent.two_direction_animation(
		motion.looking_direction.x,
		"run"
		)
	)

	# TODO: rever efetividade e nescessidade dessa lógica
	var real_velocity := character_body.get_platform_velocity().x

	var new_speed: float = abs(motion.max_speed) + real_velocity

	speed_divisor = new_speed / motion.max_speed


func _physics_update(delta: float) -> void:
	motion.input_direction = MotionComponent.update_input_direction()

	motion.looking_direction = motion.input_direction

	character_body.velocity.x = MotionComponent.move_x(
		motion.max_speed / speed_divisor,
		motion.input_direction.x
	)

	character_body.velocity.y = MotionComponent.apply_gravity(
		character_body,
		motion.max_fall_speed,
		motion.gravity,
		delta
	)

	character_body.move_and_slide()


func jump_transition() -> Array[Variant]:
	var condition := (
		Input.is_action_just_pressed("jump")
		and character_body.is_on_floor()
	)
	return [condition, null]


func fall_transition() -> Array[Variant]:
	var condition := character_body.velocity.y > 0
	return [condition, {"coyote": true}]


func idle_transition() -> Array[Variant]:
	var condition := motion.input_direction.x == 0
	return [condition, null]


func attack_transition() -> Array[Variant]:
	var condition := Input.is_action_just_pressed("attack")
	return [condition, null]


func _on_motion_component_looking_direction_changed(_old_value: Vector2, new_value: Vector2) -> void:
	var logic: Callable = func() -> void:
		if state_machine.active_state == self:
			animation_player.play(MotionComponent.two_direction_animation(
			new_value.x,
			"run"
			)
		)
	logic.call_deferred()

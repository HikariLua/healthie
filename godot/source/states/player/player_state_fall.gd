class_name PlayerStateFall
extends State

## Fall state executed when character body is falling

@export_group("Nodes")
@export var character_body: CharacterBody2D
@export var animation_player: AnimationPlayer
@export var state_machine: StateMachine
@export var ray_casts_group: Node2D
@export var coyote_timer: Timer

@export_group("Components")
@export var motion: MotionComponent

@export_group("States")
@export var jump_state: PlayerStateJump
@export var attack_air_state: PlayerStateAttackAir
@export var run_state: PlayerStateRun
@export var idle_state: PlayerStateIdle


# FIX IN 4.1, make it and exported typed array and populate from the editor
@onready var jump_ray_casts: Array[Node] = ray_casts_group.get_children()

var coyote: bool = false


func _ready() -> void:
	assert(character_body != null)
	assert(animation_player != null)
	assert(state_machine != null)
	assert(coyote_timer != null)
	assert(ray_casts_group != null)
	assert(motion != null)
	assert(jump_state != null)
	assert(run_state != null)
	assert(idle_state != null)
	assert(attack_air_state != null)

	transitions = {
		jump_state: jump_transition,
		attack_air_state: attack_air_transition,
		idle_state: idle_transition,
		run_state: run_transition
	}


func _on_enter() -> void:
	coyote = false
	enter_fall()


func _on_enter_with_message(message: Dictionary) -> void:
	assert(message.has("coyote"), "message must include coyote key")
	coyote = message["coyote"]
	enter_fall()


func enter_fall() -> void:
	coyote_timer.start(0.2)
	MotionComponent.two_direction_animation(
		animation_player,
		motion.looking_direction.x,
		"fall"
	)


func _physics_update(delta: float) -> void:
	motion.input_direction = MotionComponent.update_input_direction()

	motion.looking_direction = motion.input_direction

	MotionComponent.two_direction_animation(
		animation_player,
		motion.looking_direction.x,
		"fall"
	)

	var divisor: float = 1 if character_body.velocity.y <= 0 else 2
	character_body.velocity.y = MotionComponent.apply_gravity(
		character_body,
		motion.max_fall_speed,
		motion.gravity,
		delta / divisor
	)

	character_body.velocity.x = MotionComponent.move_x(
		motion.max_speed,
		motion.input_direction.x
	)

	character_body.move_and_slide()


func ray_casts_colliding() -> bool:
	for ray_cast in jump_ray_casts:
		if ray_cast.is_colliding():
			return true
	
	return false


func on_exit() -> void:
	coyote_timer.stop()


func jump_transition() -> Array[Variant]:
	var can_coyote := coyote_timer.time_left > 0 and coyote
	var condition := (
		Input.is_action_just_pressed("jump")
		and (can_coyote or ray_casts_colliding())
	)

	return [condition, null]


func attack_air_transition() -> Array[Variant]:
	var condition := Input.is_action_just_pressed("attack")
	return [condition, null]


func run_transition() -> Array[Variant]:
	var condition := character_body.is_on_floor() and motion.input_direction.x != 0
	return [condition, null]


func idle_transition() -> Array[Variant]:
	var condition := character_body.is_on_floor()
	return [condition, null]

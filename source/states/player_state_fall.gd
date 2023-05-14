class_name PlayerStateFall
extends State

## Fall state executed when character body is falling

@export var character_body: CharacterBody2D

@export var motion: MotionComponent


func _ready() -> void:
	assert(character_body != null)
	assert(motion != null)


func on_enter(_message := {}) -> void:
	motion.two_direction_animation(animation_player, "fall")


func physics_update(delta: float) -> void:
	motion.input_direction = motion.update_input_direction()
	
	motion.looking_direction = motion.set_looking_direction(
		motion.input_direction
	)

	motion.two_direction_animation(animation_player, "fall")
	
	var divisor: float = 1 if character_body.velocity.y <= 0 else 2
	character_body.velocity.y = motion.apply_gravity(
		character_body,
		delta / divisor
	)

	character_body.velocity.x = motion.move_x(
		motion.max_speed,
		motion.input_direction.x
	)

	character_body.move_and_slide()
	check_transitions()

	
func check_transitions() -> void:
	if Input.is_action_just_pressed("attack"):
		state_machine.transition_state_to("PlayerStateAttackAir")

	elif character_body.is_on_floor() and not motion.input_direction.x == 0:
		state_machine.transition_state_to("PlayerStateRun")

	elif character_body.is_on_floor():
		state_machine.transition_state_to("PlayerStateIdle")


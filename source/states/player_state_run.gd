class_name PlayerStateRun
extends State

## Run state executed when player is on floor

@export var character_body: CharacterBody2D

@export var motion: MotionComponent


func _ready() -> void:
	assert(character_body != null)
	assert(motion != null)


func on_enter(_message := {}) -> void:
	motion.two_direction_animation(animation_player, "run")


func physics_update(delta: float) -> void:
	motion.input_direction = motion.update_input_direction()
	
	motion.looking_direction = motion.set_looking_direction(
		motion.input_direction
	)

	motion.two_direction_animation(animation_player, "run")

	character_body.velocity.x = motion.move_x(
		motion.max_speed,
		motion.input_direction.x
	)

	character_body.velocity.y = motion.apply_gravity(
		character_body,
		delta
	)

	character_body.move_and_slide()
	check_transitions()


func check_transitions() -> void:
	if Input.is_action_just_pressed("jump") and character_body.is_on_floor():
		state_machine.transition_state_to("PlayerStateJump")

	elif character_body.velocity.y > 0:
		state_machine.transition_state_to("PlayerStateFall")

	elif not motion.input_direction.x:
		state_machine.transition_state_to("PlayerStateIdle")

	elif Input.is_action_just_pressed("attack"):
		state_machine.transition_state_to("PlayerStateAttack")


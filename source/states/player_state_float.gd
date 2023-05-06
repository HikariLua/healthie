class_name PlayerStateFloat
extends State

@export var character_body: CharacterBody2D

@export var motion: MotionComponent

@export var float_timer: Timer
@export var float_duration: float = 0.15


func on_enter(_message := {}) -> void:
	character_body.velocity.y = 0
	float_timer.start(float_duration)	

	motion.two_direction_animation(animation_player, "fall")



func physics_update(delta: float) -> void:
	motion.input_direction = motion.update_input_direction()
	
	motion.looking_direction = motion.set_looking_direction(
		motion.input_direction
	)

	motion.two_direction_animation(animation_player, "fall")

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
	if character_body.is_on_floor():
		state_machine.transition_state_to("PlayerStateIdle")
	

func _on_float_timer_timeout() -> void:
	state_machine.transition_state_to("PlayerStateFall")


func on_exit() -> void:
	float_timer.stop()

class_name PlayerStateRun
extends State

## Run state executed when player is on floor

@export var character_body: CharacterBody2D

@export var motion: MotionComponent

var speed_divisor: float


func _ready() -> void:
	assert(character_body != null)
	assert(motion != null)


func on_enter(_message := {}) -> void:
	motion.two_direction_animation(animation_player, "run")

	var real_velocity = character_body.get_platform_velocity().x

	var new_speed: float = abs(motion.max_speed) + real_velocity

	speed_divisor = new_speed / motion.max_speed


func physics_update(delta: float) -> void:
	motion.input_direction = motion.update_input_direction()
	print("real_vel= %s" % character_body.get_real_velocity())
	print("platform_vel= %s" % character_body.get_platform_velocity())
	print("vel= %s\n" % character_body.velocity)

	motion.looking_direction = motion.set_looking_direction(
		motion.input_direction
	)

	motion.two_direction_animation(animation_player, "run")

	character_body.velocity.x = motion.move_x(
		motion.max_speed / speed_divisor, motion.input_direction.x
	)

	character_body.velocity.y = motion.apply_gravity(character_body, delta)

	character_body.move_and_slide()
	check_transitions()


func check_transitions() -> void:
	if Input.is_action_just_pressed("jump") and character_body.is_on_floor():
		state_machine.transition_state_to("PlayerStateJump")

	elif character_body.velocity.y > 0:
		state_machine.transition_state_to("PlayerStateFall", {"coyote": true})

	elif not motion.input_direction.x:
		state_machine.transition_state_to("PlayerStateIdle")

	elif Input.is_action_just_pressed("attack"):
		state_machine.transition_state_to("PlayerStateAttack")


func on_exit() -> void:
	pass

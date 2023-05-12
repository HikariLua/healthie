class_name PlayerStateJump
extends State

## Jump state executed when the player is on floor
@export var character_body: CharacterBody2D
@export var jump_sfx: AudioStreamPlayer2D

@export var motion: MotionComponent

@onready var min_jump_velocity: float = motion.jump_velocity / 2


func _ready() -> void:
	assert(character_body != null)
	assert(motion != null)


func on_enter(_message := {}) -> void:
	motion.two_direction_animation(animation_player, "jump")
	character_body.velocity.y = motion.jump_velocity
	
	jump_sfx.play()


func physics_update(delta: float) -> void:
	motion.input_direction = motion.update_input_direction()
	
	motion.looking_direction = motion.set_looking_direction(
		motion.input_direction
	)

	motion.two_direction_animation(animation_player, "jump")

	character_body.velocity.x = motion.move_x(
		motion.max_speed,
		motion.input_direction.x
	)

	character_body.velocity.y = motion.apply_gravity(
		character_body,
		delta
	)

	if Input.is_action_just_released("jump"):
		regulate_jump()

	character_body.move_and_slide()
	check_transitions()


func regulate_jump() -> void:
	if character_body.velocity.y < min_jump_velocity:
		character_body.velocity.y = min_jump_velocity

	
func check_transitions() -> void:
	if Input.is_action_just_pressed("attack"):
		state_machine.transition_state_to("PlayerStateAttackAir")
		
	elif character_body.is_on_floor() and not motion.input_direction.x == 0:
		state_machine.transition_state_to("PlayerStateRun")

	elif character_body.is_on_floor():
		state_machine.transition_state_to("PlayerStateIdle")

	elif character_body.velocity.y >= 0:
		state_machine.transition_state_to("PlayerStateFall")

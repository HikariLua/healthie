class_name PlayerStateSpin
extends State

@export var character_body: CharacterBody2D
@export var spin_music: AudioStreamPlayer2D

@export var motion: MotionComponent


func on_enter(_message := {}) -> void:
	animation_player.play("spin")
	spin_music.play(61.45)


func physics_update(delta: float) -> void:
	motion.input_direction = motion.update_input_direction()
	
	character_body.velocity.x = 0

	character_body.velocity.y = motion.apply_gravity(
		character_body,
		delta
	)

	character_body.move_and_slide()
	check_transitions()


func check_transitions() -> void:
	if Input.is_action_just_pressed("jump"):
		state_machine.transition_state_to("PlayerStateJump")

	elif motion.input_direction.x:
		state_machine.transition_state_to("PlayerStateRun")


func on_exit() -> void: 
	spin_music.stop()
		

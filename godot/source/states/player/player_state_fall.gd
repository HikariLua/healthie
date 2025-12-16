class_name PlayerStateFall
extends State

## Fall state executed when character body is falling

@export var character_body: CharacterBody2D
@export var ray_casts_group: Node2D


@export var motion: MotionComponent

@export var coyote_timer: Timer

# FIX IN 4.1, make it and exported typed array and populate from the editor
@onready var jump_ray_casts: Array[Node] = ray_casts_group.get_children()

var coyote: bool = false


func _ready() -> void:
	assert(character_body != null)
	assert(motion != null)


func on_enter(message := {}) -> void:
	if message.has("coyote"):
		coyote = message["coyote"]
	else:
		coyote = false

	coyote_timer.start(0.2)

	motion.two_direction_animation(animation_player, "fall")


func physics_update(delta: float) -> void:
	motion.input_direction = motion.update_input_direction()

	motion.looking_direction = motion.set_looking_direction(
		motion.input_direction
	)

	motion.two_direction_animation(animation_player, "fall")

	var divisor: float = 1 if character_body.velocity.y <= 0 else 2
	character_body.velocity.y = motion.apply_gravity(
		character_body, delta / divisor
	)

	character_body.velocity.x = motion.move_x(
		motion.max_speed, motion.input_direction.x
	)

	character_body.move_and_slide()
	check_transitions()


func check_transitions() -> void:
	if Input.is_action_just_pressed("jump"):
		if coyote_timer.time_left > 0 and coyote:
			state_machine.transition_state_to("PlayerStateJump")
		elif ray_casts_colliding():
			state_machine.transition_state_to("PlayerStateJump")

	elif Input.is_action_just_pressed("attack"):
		state_machine.transition_state_to("PlayerStateAttackAir")

	elif character_body.is_on_floor() and not motion.input_direction.x == 0:
		state_machine.transition_state_to("PlayerStateRun")

	elif character_body.is_on_floor():
		state_machine.transition_state_to("PlayerStateIdle")


func ray_casts_colliding() -> bool:
	for ray_cast in jump_ray_casts:
		if ray_cast.is_colliding():
			return true
	
	return false


func on_exit() -> void:
	coyote_timer.stop()

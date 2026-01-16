extends Node

## A group of reusable data used for moving a character

@export var jump_velocity: float = -32 * 8.7
@export var max_speed: float = 92 
@export var max_fall_speed: float = 200

@export var looking_direction := Vector2.RIGHT
@export var was_on_floor: bool = false

var input_direction := Vector2.ZERO

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")


func update_input_direction() -> Vector2:
	var new_input_direction := Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")
	)
	
	if not new_input_direction.x == 0:
		new_input_direction.x = 1 if new_input_direction.x > 0 else -1
	
	if not new_input_direction.y == 0:
		new_input_direction.y = 1 if new_input_direction.y > 0 else -1
	
	return new_input_direction


func set_looking_direction(new_looking_direction: Vector2) -> Vector2:
	if new_looking_direction.x == 0:
		return looking_direction
	
	return new_looking_direction


func apply_gravity(body: CharacterBody2D, delta: float) -> float:
	if body.is_on_floor():
		return body.velocity.y

	return move_toward(body.velocity.y, max_fall_speed, gravity * delta)


func move_x(speed: float, direction: float) -> float:
	return speed * direction


# This function has side effects
## Set animation based on the looking direction
func two_direction_animation(
		animation_player: AnimationPlayer,
		animation_prefix: String
	) -> void:

	var suffix: String = "-left" if looking_direction.x < 0 else "-right"
	var new_animation: String = animation_prefix + suffix

	if new_animation == animation_player.current_animation:
		return

	assert(animation_player.has_animation(new_animation))

	animation_player.play(new_animation)

class_name EnemyStateRoll
extends State

@export var character_body: CharacterBody2D
@export var motion: MotionComponent

@export var max_roll: float

func _ready() -> void:
	assert(character_body != null)
	assert(motion != null)

func on_enter(_message := {}) -> void:
	motion.two_direction_animation(animation_player, "run")

func physics_update(delta: float) -> void:
	motion.two_direction_animation(animation_player, "run")

	character_body.velocity.x = motion.move_x(
		max_roll,
		motion.looking_direction.x 
	)

	character_body.velocity.y = motion.apply_gravity(
		character_body,
		delta
	)
	
	character_body.move_and_slide()



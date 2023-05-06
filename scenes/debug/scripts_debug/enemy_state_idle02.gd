class_name EnemyStateIdle02
extends State

@export var character_body: CharacterBody2D
@export var motion: MotionComponent

func _ready() -> void:
	assert(character_body != null)
	assert(motion != null)

func on_enter(_message := {}) -> void:
	motion.two_direction_animation(animation_player, "idle")
	character_body.velocity.x = 0


func physics_update(delta: float) -> void:
	character_body.velocity.y = motion.apply_gravity(
		character_body,
		delta
	)

	character_body.move_and_slide()

func _on_player_detect_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		state_machine.transition_state_to("EnemyStateRoll")


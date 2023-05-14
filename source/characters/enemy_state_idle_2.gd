class_name EnemyStateIdle03
extends State

@export var character_body: CharacterBody2D
@export var motion: MotionComponent

@export var idle_duration: float = 2
@export var idle_timer: Timer

@export var flips: bool = true


func _ready() -> void:
	assert(character_body != null)
	assert(motion != null)
	assert(idle_timer != null)


func on_enter(_message := {}) -> void:
	idle_timer.start(idle_duration)

	motion.two_direction_animation(animation_player, "idle")

	character_body.velocity.x = 0


func physics_update(delta: float) -> void:
	character_body.velocity.y = motion.apply_gravity(
		character_body,
		delta
	)

	character_body.move_and_slide()


func _on_idle_timer_timeout() -> void:
	state_machine.transition_state_to("EnemyStateRoam01")


func on_exit() -> void:
	idle_timer.stop()

	if flips:
		motion.looking_direction = motion.set_looking_direction(
			motion.looking_direction * -1
		)

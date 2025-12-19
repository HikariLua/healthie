class_name EnemyStateRoam01
extends State

@export var character_body: CharacterBody2D
@export var motion: MotionComponent

@export var roam_timer: Timer
@export var roam_duration: float = 4


func _ready() -> void:
	assert(character_body != null)
	assert(motion != null)
	assert(roam_timer != null)


func on_enter(_message := {}) -> void:
	roam_timer.start(roam_duration)
	#motion.two_direction_animation(animation_player, "run")


func physics_update(delta: float) -> void:
	#motion.two_direction_animation(animation_player, "run")

	character_body.velocity.x = motion.move_x(
		motion.max_speed,
		motion.looking_direction.x
	)

	#character_body.velocity.y = motion.apply_gravity(
		#character_body,
		#delta
	#)
	#
	character_body.move_and_slide()

	#check_walls()


#func check_walls() -> void:
	#if character_body.is_on_wall():
		#motion.looking_direction = motion.set_looking_direction(
			#motion.looking_direction * -1
		#)
		#character_body.global_position += motion.looking_direction
#
#
#func _on_roam_timer_timeout() -> void:
	#state_machine.transition_state_to("EnemyStateIdle01")


func on_exit() -> void:
	roam_timer.stop()

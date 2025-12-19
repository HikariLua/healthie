class_name EnemyStateIdle01
extends State

@export_group("Nodes")
@export var character_body: CharacterBody2D
@export var idle_timer: Timer
@export var animation_player: AnimationPlayer
@export var state_machine: StateMachine

@export_group("Components")
@export var motion: MotionComponent

@export_group("States")
@export var roam_state: EnemyStateRoam01


@export var idle_duration: float = 202
@export var flips: bool = true


func _ready() -> void:
	assert(character_body != null)
	assert(motion != null)
	assert(roam_state != null)
	assert(idle_timer != null)
	
	transitions = {
		roam_state: roam_transition
	}


func _on_enter() -> void:
	idle_timer.start(idle_duration)
	
	MotionComponent.two_direction_animation(
		animation_player,
		motion.looking_direction.x,
		"idle"
	)


func _physics_update(delta: float) -> void:
	character_body.velocity.x = 0
	
	character_body.velocity.y = MotionComponent.apply_gravity(
		character_body,
		motion.max_fall_speed,
		motion.gravity,
		delta
	)
	
	motion.was_on_floor = character_body.is_on_floor()
	
	character_body.move_and_slide()


#func _on_idle_timer_timeout() -> void:
	#state_machine.transition_state_to("EnemyStateRoam01")

func roam_transition() -> Array[Variant]:
	print(idle_timer.time_left)
	var condition := (
		Input.is_action_just_pressed("jump")
		and character_body.is_on_floor()
	)

	return [condition, null]

func on_exit() -> void:
	idle_timer.stop()

	#if flips:
		#motion.looking_direction = motion.set_looking_direction(
			#motion.looking_direction * -1
		#)

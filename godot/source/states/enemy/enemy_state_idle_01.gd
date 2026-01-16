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
@export var roam_state: State

@export var idle_duration: float = 2
@export var flips: bool = true


func _ready() -> void:
	assert(character_body != null)
	assert(motion != null)
	assert(roam_state != null)
	assert(idle_timer != null)
	
	idle_timer.timeout.connect(_on_idle_timer_timeout)


func _on_enter() -> void:
	idle_timer.start(idle_duration)
	
	animation_player.play(MotionComponent.two_direction_animation(
		motion.looking_direction.x,
		"idle"
		)
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


func _on_idle_timer_timeout() -> void:
	state_machine.transition_state(roam_state)


func _on_exit() -> void:
	idle_timer.stop()

	if flips:
		motion.looking_direction *= -1

class_name EnemyStateRoam01
extends State

@export_group("Nodes")
@export var character_body: CharacterBody2D
@export var roam_timer: Timer
@export var animation_player: AnimationPlayer
@export var state_machine: StateMachine

@export_group("Components")
@export var motion: MotionComponent

@export_group("States")
@export var idle_state: State
@export var roam_duration: float = 4


func _ready() -> void:
	assert(character_body != null)
	assert(motion != null)
	assert(roam_timer != null)
	
	roam_timer.timeout.connect(_on_roam_timer_timeout)


func _on_enter() -> void:
	roam_timer.start(roam_duration)
	


func _physics_update(delta: float) -> void:
	character_body.velocity.x = MotionComponent.move_x(
		motion.max_speed,
		motion.looking_direction.x
	)
	
	character_body.velocity.y = MotionComponent.apply_gravity(
		character_body,
		motion.max_fall_speed,
		motion.gravity,
		delta
	)
	
	character_body.move_and_slide()
	
	MotionComponent.two_direction_animation(
		animation_player,
		motion.looking_direction.x,
		"run"
	)
	
	check_walls()


func check_walls() -> void:
	if character_body.is_on_wall():
		motion.looking_direction = motion.looking_direction * -1
		
		character_body.global_position += motion.looking_direction


func _on_roam_timer_timeout() -> void:
	state_machine.transition_state(idle_state)


func _on_exit() -> void:
	roam_timer.stop()

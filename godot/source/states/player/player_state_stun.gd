class_name PlayerStateStun
extends State


@export var stun_duration: float = 0.5
@export var invincibility_duration: float = 3
@export var knockback_duration: float = 0.2
@export var knockback_distance := Vector2(8, -20)

@export_group("Nodes")
@export var character_body: CharacterBody2D
@export var animation_player: AnimationPlayer
@export var effect_animation_player: AnimationPlayer
@export var state_machine: StateMachine
@export var stun_timer: Timer
@export var hurtbox: Area2D
@export var invincibility_timer: Timer

@export_group("Components")
@export var motion: MotionComponent

@export_group("States")
@export var idle_state: PlayerStateIdle

@onready var knockback_speed: Vector2 = knockback_distance / knockback_duration


func _ready() -> void:
	assert(character_body != null)
	assert(animation_player != null)
	assert(state_machine != null)
	assert(effect_animation_player != null)
	assert(stun_timer != null)
	assert(motion != null)
	assert(hurtbox != null)
	assert(invincibility_timer != null)
	assert(idle_state != null)

	hurtbox.area_entered.connect(_on_hurtbox_area_entered)
	stun_timer.timeout.connect(_on_stun_timer_timeout)


func _on_hurtbox_area_entered(area: Area2D) -> void:
	var direction: Vector2 = get_knockback_direction(area)

	state_machine.transition_state_with_message(
		self,
		{"direction": direction * -1}
	)


func _on_enter_with_message(message: Dictionary) -> void:
	MotionComponent.two_direction_animation(
		animation_player,
		motion.looking_direction.x,
		"stun"
	)
	
	stun_timer.start(stun_duration)

	var direction: Vector2 = message["direction"]

	apply_knockback(direction)


func _physics_update(delta: float) -> void:
	character_body.velocity.y = MotionComponent.apply_gravity(
		character_body,
		motion.max_fall_speed,
		motion.gravity,
		delta / 2
	)
	
	character_body.move_and_slide()


func get_knockback_direction(attacker_hitbox: Area2D) -> Vector2:
	var direction: Vector2 = character_body.global_position.direction_to(
		attacker_hitbox.global_position
	)

	# This logic will make the knockback speed consistant
	direction.x = -1 if direction.x <= 0 else 1
	direction.y = -1

	return direction
	
	
func apply_knockback(direction: Vector2) -> void:
	character_body.velocity = knockback_speed * direction 

	await get_tree().create_timer(knockback_duration).timeout
	character_body.velocity.x = 0


func _on_exit() -> void:
	stun_timer.stop()


func _on_stun_timer_timeout() -> void:
	state_machine.transition_state(idle_state)

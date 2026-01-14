extends State

@export_group("Nodes")
@export var animation_player: AnimationPlayer
@export var shoot_sfx: AudioStreamPlayer2D
@export var character_body: CharacterBody2D
@export var state_machine: StateMachine

@export_group("Components")
@export var motion: MotionComponent

@export_group("States")
@export var idle_state: EnemyStateIdle01
@export var shoot_speed: float = 70

var junk_food: PackedScene = preload(
	"uid://dihivu0kmp7xx"
)


func on_enter(_message := {}) -> void:
	var food: ProjectileWrapper = junk_food.instantiate()

	food.global_position = character_body.global_position + Vector2(0, -8)
	food.speed = self.shoot_speed
	food.direction = motion.looking_direction.normalized()
	
	ProjectileManagerAutoload.spawn_projectile(food)
	
	animation_player.play(MotionComponent.two_direction_animation(
		motion.looking_direction.x,
		"shoot"
		)
	)
	
	shoot_sfx.play()


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
#	if not state_machine.active_state == self:
#		return
	if not _anim_name == "shoot":
		return
	
	state_machine.transition_state(idle_state)

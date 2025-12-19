class_name PlayerStateDie
extends State

@export_group("Nodes")
@export var character_body: CharacterBody2D
@export var animation_player: AnimationPlayer
@export var state_machine: StateMachine
@export var die_sfx: AudioStreamPlayer2D
@export var hurtbox_collision: CollisionShape2D
@export var collectible_collision: CollisionShape2D

@export_group("Components")
@export var health: HealthComponent
@export var motion: MotionComponent
@export var collectible: CollectibleComponent

var death_screen: CanvasLayer = preload("uid://c4usia3843yl7").instantiate()


func _ready() -> void:
	assert(character_body != null)
	assert(animation_player != null)
	assert(state_machine != null)
	assert(collectible != null)
	assert(die_sfx != null)
	assert(hurtbox_collision != null)
	assert(collectible_collision != null)
	assert(motion != null)


func _on_enter() -> void:
	die_sfx.play()
	
	
	if health.lifes > 0:
		health.lifes -= 1
		get_tree().get_root().add_child(death_screen)
		TransitionScreen.reload_scene(self.get_tree())
		
	else:
		TransitionScreen.transition_to(
			"res://scenes/screens/game_over_screen.tscn",
			get_tree()
		)
	
	collectible.collect_sequence = -100
	hurtbox_collision.set_deferred("disabled", true)
	collectible_collision.set_deferred("disabled", true)
	MotionComponent.two_direction_animation(
		animation_player,
		motion.looking_direction.x,
		"die"
	)

	character_body.velocity.x = 0


func _physics_update(delta: float) -> void:
	character_body.velocity.y = MotionComponent.apply_gravity(
		character_body,
		motion.max_fall_speed,
		motion.gravity,
		delta 
	)

	character_body.move_and_slide()

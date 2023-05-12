class_name PlayerStateDie
extends State

@export var character_body: CharacterBody2D
@export var motion: MotionComponent
@export var die_sfx: AudioStreamPlayer2D

@export var hurtbox_collision: CollisionShape2D
@export var collectible_collision: CollisionShape2D

var death_screen: CanvasLayer = preload(
	"res://scenes/screens/death_screen.tscn"
).instantiate()


func _ready() -> void:
	assert(character_body != null)


func on_enter(_message := {}) -> void:
	die_sfx.play()
	
	if PlayerInfo.lifes > 0:
		PlayerInfo.lifes -= 1
		get_tree().get_root().add_child(death_screen)
		TransitionScreen.reload_scene(self.get_tree())
		
	else:
		TransitionScreen.transition_to(
			"res://scenes/screens/game_over_screen.tscn",
			get_tree()
		)
	
	hurtbox_collision.set_deferred("disabled", true)
	collectible_collision.set_deferred("disabled", true)
	motion.two_direction_animation(animation_player, "die")

	character_body.velocity.x = 0


func physics_update(delta: float) -> void:
	character_body.velocity.y = motion.apply_gravity(character_body, delta)

	character_body.move_and_slide()

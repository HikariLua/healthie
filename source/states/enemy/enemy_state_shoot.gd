extends State

@export var motion: MotionComponent
@export var shoot_sfx: AudioStreamPlayer2D
@export var character_body: CharacterBody2D

@export var shoot_speed: float = 70

var standard_food: PackedScene = preload(
	"res://scenes/collectibles/junk_food.tscn"
)


func on_enter(_message := {}) -> void:
	var food: StandardFood = standard_food.instantiate()

	food.global_position = character_body.global_position + Vector2(0, -8)
	food.speed = self.shoot_speed
	food.direction = motion.looking_direction.normalized()
	
	get_tree().get_root().add_child(food)
	motion.two_direction_animation(animation_player, "shoot")
	shoot_sfx.play()


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	if state_machine.active_state != self:
		return
	
	state_machine.transition_state_to("EnemyStateIdle01")

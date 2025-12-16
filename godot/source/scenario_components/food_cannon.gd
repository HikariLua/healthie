class_name FoodCannon
extends StaticBody2D

@export var timer: Timer
@export var timer_duration: float = 2
@export var delay: float = 0
@export var animation_player: AnimationPlayer

@export var shoot_sfx: AudioStreamPlayer2D

@export var shoot_speed: float = 70

@export var direction := Vector2.LEFT

var junk_food: PackedScene = preload(
	"res://scenes/collectibles/junk_food.tscn"
)


func _ready() -> void:
	if not delay == 0:
		timer.start(delay)
		await timer.timeout
	
	timer.wait_time = timer_duration
	
	animation_player.speed_scale = 1 / timer_duration
	animation_player.play("blink")
	
	timer.start()


func _on_timer_timeout() -> void:
	var food: JunkFood = junk_food.instantiate()

	food.global_position = self.global_position
	food.speed = self.shoot_speed
	food.direction = self.direction.normalized()
	
	get_tree().get_root().add_child(food)
	shoot_sfx.play()

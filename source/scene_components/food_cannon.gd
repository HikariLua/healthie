extends StaticBody2D

@export var timer: Timer
@export var timer_duration: float = 2

@export var shoot_speed: float = 70

@export var direction := Vector2.LEFT


func _ready() -> void:
	timer.wait_time = timer_duration
	timer.start()


func _on_timer_timeout() -> void:
	var food: StandardFood = preload(
		"res://scenes/collectibles/standard_food.tscn"
	).instantiate()

	food.global_position = self.global_position
	food.speed = self.shoot_speed
	food.direction = self.direction
	
	get_tree().get_root().add_child(food)

extends Area2D

@export var motion: MotionComponent
@export var animation_player: AnimationPlayer
@export var speed_scale: float = 3


var normal_speed: float

#func _on_body_entered(_body: Node2D) -> void:
	#animation_player.speed_scale = speed_scale
	#normal_speed = motion.max_speed
	#motion.max_speed *= speed_scale
#
#
#func _on_body_exited(_body: Node2D) -> void:
	#animation_player.speed_scale = 1
	#motion.max_speed = normal_speed

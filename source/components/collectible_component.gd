class_name CollectibleComponent
extends Node

@export var sequence_timer: Timer
@export var sequence_duration: float = 5
@export var pickup_sfx: AudioStreamPlayer2D
@export var effect: AnimationPlayer

@export var state_machine: StateMachine

var collected_food: int = 0
var collect_sequence: int = 0


func _on_interactbox_area_entered(_area: Area2D) -> void:
	collected_food += 1
	collect_sequence += 1
	pickup_sfx.play()
	effect.play("hit")
	
	if collect_sequence >= 8:
		state_machine.transition_state_to("PlayerStateDie")
		return
	
	sequence_timer.start(sequence_duration)


func _on_sequence_timer_timeout() -> void:
	collect_sequence = 0

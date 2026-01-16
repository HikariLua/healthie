extends Node

## Base state class to control character's behavior

## Reference to AnimationPlayer for controling the animations of a state
@export var animation_player: AnimationPlayer

@onready var state_machine: StateMachine = find_parent("StateMachine")


func _ready() -> void:
	assert(animation_player != null)
	assert(state_machine != null)


# Virtual functions to be overriden by each individual state
## Function to run every frame (replacement to _physics_process)
func update(_delta: float) -> void:
	pass

## Function to run every physical frame update
func physics_update(_delta: float) -> void:
	pass


## Executed when entered in the state
func on_enter(_message := {}) -> void:
	pass


## Executed when exited from the state
func on_exit() -> void:
	pass

extends Node

## A simple finite state machine to manage the behavior of complex objects

@export var initial_state: State

@onready var active_state: State = initial_state


func _ready() -> void:
	assert(initial_state != null)
	
	active_state.on_enter()


func _physics_process(delta: float) -> void:
	active_state.physics_update(delta)


func _process(delta: float) -> void:
	active_state.update(delta)


func transition_state_to(target_state: String, message := {}) -> bool:
	# Avoid transition to non existent state
	if not has_node(target_state):
		return false

	active_state.on_exit()

	active_state = get_node(target_state) as State

	active_state.on_enter(message)

	return true

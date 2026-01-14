class_name DeathHole
extends Area2D


func _on_body_entered(body: Node2D) -> void:
	var state_machine: StateMachine = body.get_node("StateMachine")
	
	if state_machine.active_state.name.containsn("die"):
		return
	
	var states: Array[Node] = state_machine.get_children()
	
	for state in states:
		if state.name.containsn("die"):
			state_machine.transition_state(state)

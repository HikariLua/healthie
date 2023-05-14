class_name DeathHole
extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.get_node("StateMachine").active_state.name == "PlayerStateDie":
		return
	
	body.get_node("StateMachine").transition_state_to("PlayerStateDie")

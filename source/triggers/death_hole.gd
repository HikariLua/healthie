class_name DeathHole
extends Area2D


func _on_body_entered(body: Node2D) -> void:
	body.get_node("StateMachine").transition_state_to("PlayerStateDie")

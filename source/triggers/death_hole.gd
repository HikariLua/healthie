class_name DeathHole
extends Area2D

var death_screen: DeathScreen = preload(
	"res://scenes/screens/death_screen.tscn"
).instantiate()


func _on_body_entered(body: Node2D) -> void:
	body.get_node("Components/HealthComponent").health_points = 0
	body.get_node("StateMachine").transition_state_to("PlayerStateDie")

	get_tree().get_root().add_child(death_screen)
	death_screen.transition()


extends Area2D

@export var requierd_health: int = 85
@export var clear_sfx: AudioStreamPlayer2D
@export var extra_clear_sfx: AudioStreamPlayer2D
@export var next_level_index: int

var health: int = 100
var player: CharacterBody2D

var final_health: int
var result: String
var plus: String

var end_stage_screen: PackedScene = preload(
	"res://scenes/screens/end_stage_screen.tscn"
)


func _on_body_entered(body: Node2D) -> void:
	player = body as CharacterBody2D
	var health_component = player.get_node("Components/HealthComponent")

	var state_machine: StateMachine = (
		player.get_node("StateMachine") as StateMachine
	)

	player.get_node("Interactbox/CollisionShape2D").set_deferred(
		"disabled", true
	)

	state_machine.set_physics_process(false)
	var player_food: int = (
		player.get_node("Components/CollectibleComponent").collected_food
	)
	final_health = health - player_food

	if final_health < requierd_health:
		result = "Fail"
		show_sceen()

		await get_tree().create_timer(6).timeout
		player.get_node("StateMachine").transition_state_to("PlayerStateDie")

	elif final_health >= requierd_health + 8:
		result = "Extra Success"
		plus = "+2 Lifes"
		health_component.lifes += 2
		extra_clear_sfx.play()

		show_sceen()
		await get_tree().create_timer(6).timeout
		next_level()

	else:
		result = "Success"
		plus = "+1 Life"
		health_component.lifes += 1
		show_sceen()
		clear_sfx.play()
		await get_tree().create_timer(6).timeout
		next_level()


func next_level() -> void:
	TransitionScreen.transition_to(
		"res://scenes/levels/level_%s.tscn" % next_level_index, get_tree()
	)


func show_sceen() -> void:
	var end_screen: CanvasLayer = end_stage_screen.instantiate()

	end_screen.requierd.text = "Requierd Health: " + str(requierd_health)
	end_screen.final.text = "Final Health: " + str(final_health)
	end_screen.result.text = result
	end_screen.plus.text = plus
	get_tree().get_root().add_child(end_screen)

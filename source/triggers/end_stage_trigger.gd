extends Area2D

@export var requierd_health: int = 85
@export var clear_sfx: AudioStreamPlayer2D
@export var extra_clear_sfx: AudioStreamPlayer2D

var health: int = 100
var player: CharacterBody2D

var final_health: int
var result: String
var plus: String

var end_stage_screen: PackedScene = preload("res://scenes/screens/end_stage_screen.tscn")

func _on_body_entered(body: Node2D) -> void:
	player = body as CharacterBody2D
	var state_machine: StateMachine = player.get_node("StateMachine") as StateMachine
	
	state_machine.set_physics_process(false)
	var player_food: int = player.get_node("Components/CollectibleComponent").collected_food
	final_health = health - player_food

	
	if final_health < requierd_health:
		result = "Fail"
		show_sceen()
		
		await get_tree().create_timer(7).timeout
		player.get_node("StateMachine").transition_state_to("PlayerStateDie")

	elif final_health > requierd_health + 5:
		result = "Extra Success"
		plus = "+1 Life"
		PlayerInfo.lifes += 1
		extra_clear_sfx.play()
		
		show_sceen()
		PlayerInfo.current_level += 1
		await get_tree().create_timer(7).timeout
		next_level()
		
	else:
		result = "Success"
		show_sceen()
		clear_sfx.play()
		PlayerInfo.current_level += 1
		await get_tree().create_timer(7).timeout
		next_level()


func next_level() -> void:
	TransitionScreen.transition_to(
		"res://scenes/levels/level_%s.tscn" % PlayerInfo.current_level,
		get_tree()
	)


func show_sceen() -> void:
	var end_screen: CanvasLayer = end_stage_screen.instantiate()
	
	end_screen.requierd.text = "Requierd Health: " + str(requierd_health)
	end_screen.final.text = "Final Health: " + str(final_health)
	end_screen.result.text = result
	end_screen.plus.text = plus
	get_tree().get_root().add_child(end_screen)
	
	await get_tree().create_timer(7).timeout
	
	end_screen.queue_free()

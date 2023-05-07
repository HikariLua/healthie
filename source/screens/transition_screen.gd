extends CanvasLayer

signal transition_complete
signal fade_outed

@export var animation_player: AnimationPlayer

var scene: String


func transition_to(path: String) -> void:
	scene = path
	animation_player.play("fade_out")
	
	await animation_player.animation_changed
	get_tree().change_scene_to_file(scene)



func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_out":
		emit_signal("fade_outed")
		animation_player.play("fade_in")
	
	if anim_name == "fade_in":
		emit_signal('transition_complete')
	

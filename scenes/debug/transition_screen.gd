extends CanvasLayer

@export var animation_player: AnimationPlayer

var name_scene: String

signal transition_complete

func transition():
	animation_player.play('fade_in')

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == 'fade_in':
		get_tree().change_scene_to_file(name_scene)
		animation_player.play('fade_out')
	if anim_name == 'fade_out':
		emit_signal('transition_complete')
	

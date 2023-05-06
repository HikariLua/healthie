class_name DeathScreen
extends CanvasLayer

@export var animation_player: AnimationPlayer


func transition() -> void:
	animation_player.play("fade_out")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_out":
		get_tree().reload_current_scene()
		animation_player.play("fade_in")

	if anim_name == "fade_in":
		queue_free()

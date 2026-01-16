extends Control

@export var animation_player: AnimationPlayer
@export var animation_fade: AnimationPlayer


func _ready() -> void:
	animation_player.play("intro")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if not anim_name == "intro":
		return
	
	animation_player.play("frame-rotation")
	animation_fade.play("fade-out")


func _on_animation_player_fade_animation_finished(_anim_name: StringName) -> void:
	TransitionScreenAutoload.transition_to("uid://cx13u703swmfu", get_tree())

extends Area2D

@export var text_label: Label
@export var color_rect: ColorRect
@export var message_node: Node2D
@export var animation_player: AnimationPlayer

@export var open_sfx: AudioStreamPlayer2D
@export var close_sfx: AudioStreamPlayer2D


func _on_body_entered(_body: Node2D) -> void:
	color_rect.size = text_label.size
	color_rect.position = text_label.position
	color_rect.scale = text_label.scale
	
	message_node.show()
	
	animation_player.play("in")
	open_sfx.play()


func _on_body_exited(_body: Node2D) -> void:
	message_node.hide()
	animation_player.play("out")
	close_sfx.play()

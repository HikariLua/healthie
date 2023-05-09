extends Area2D

@export var text_label: Label
@export var color_rect: ColorRect
@export var message_node: Node2D

@export var message: String = "Sample message"


func _on_body_entered(_body: Node2D) -> void:
	color_rect.size = text_label.size
	color_rect.position = text_label.position
	color_rect.scale = text_label.scale
	
	text_label.text = message
	message_node.show()


func _on_body_exited(_body: Node2D) -> void:
	message_node.hide()

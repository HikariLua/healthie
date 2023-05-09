extends CanvasLayer

signal transition_complete
signal fade_outed

@export var animation_player: AnimationPlayer

var scene: String
var player: CharacterBody2D


func transition_to(path: String, tree) -> void:
	scene = path
	animation_player.play("fade_out")
	
	await animation_player.animation_finished
	tree.change_scene_to_file(scene)
	
	delete_projectiles()


func reload_scene(tree: SceneTree) -> void:
	animation_player.play("fade_out")
	
	await animation_player.animation_finished
	tree.reload_current_scene()
	delete_projectiles()


func delete_projectiles() -> void:
	var nodes = get_tree().get_nodes_in_group("projectile")
	for node in nodes:
		node.queue_free()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_out":
		emit_signal("fade_outed")
		animation_player.play("fade_in")
	
	if anim_name == "fade_in":
		emit_signal('transition_complete')
	

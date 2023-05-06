class_name HealthComponent
extends Node

signal damage_taken(previous_hp: int, attacker_hitbox: Area2D)

@export var max_health: int = 6

@onready var health_points: int = max_health


func take_damage(attacker_hitbox: Area2D) -> void:
	var previous_health: int = health_points
	health_points -= attacker_hitbox.damage
	
	emit_signal("damage_taken", previous_health, attacker_hitbox)


func _on_hurtbox_area_entered(area: Area2D) -> void:
	take_damage(area)


# func _on_hurtbox_body_entered(body: Node2D) -> void:
# 	health_points = take_damage(body.damage)

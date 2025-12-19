class_name BodyHitbox
extends Area2D

@export var combat: CombatComponent 

#@onready var damage: int = combat.contact_damage


#func _ready() -> void:
	#assert(combat != null)


func update_damage(new_damage: int) -> int:
	return new_damage

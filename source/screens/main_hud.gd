extends Control

@export var collectible: CollectibleComponent
@export var food_label: Label


func _process(_delta: float) -> void:
	food_label.text = "Food = " + str(collectible.collected_food)

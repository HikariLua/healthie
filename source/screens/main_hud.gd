extends CanvasLayer

@export var collectible: CollectibleComponent
@export var food_label: Label
@export var food_bar: ProgressBar
@export var time_bar: ProgressBar
@export var lifes: Label


func _ready() -> void:
	time_bar.max_value = collectible.sequence_duration


func _process(_delta: float) -> void:
	food_label.text = "= " + str(collectible.collected_food)
	lifes.text = "= " + str(PlayerInfo.lifes)
	
	food_bar.value = collectible.collect_sequence
	time_bar.value = collectible.sequence_timer.time_left

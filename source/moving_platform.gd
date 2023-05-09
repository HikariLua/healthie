extends TileMap


func _physics_process(delta: float) -> void:
	position.x += 1 * delta

extends Camera2D

@export var direction: Vector2 = Vector2(0.7, 0)

func _physics_process(_delta: float) -> void:
	self.position += direction

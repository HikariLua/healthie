extends Area2D

@export var character_body: CharacterBody2D
@export var camera: Camera2D
@export var limit_top: int
@export var limit_bottom: int

var player_in_area = false

func _ready() -> void:
	assert(character_body != null)
	assert(camera != null)
	set_physics_process(false)

func _physics_process(_delta: float) -> void:
	if player_in_area and character_body.is_on_floor():
		camera.limit_top = limit_top
		camera.limit_bottom = limit_bottom

func _on_body_entered(_body: Node2D) -> void:
	set_physics_process(true)
	player_in_area = true

func _on_body_exited(_body: Node2D) -> void:
	set_physics_process(false)
	player_in_area = false

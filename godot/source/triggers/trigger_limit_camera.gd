extends Area2D

@export var character_body: CharacterBody2D
@export var camera: Camera2D
@export var limit_left: int

var player_in_area: bool = false

func _ready() -> void:
	assert(character_body != null)
	assert(camera != null)
	set_physics_process(false)


func _physics_process(_delta: float) -> void:
	camera.limit_left = 5039


func _on_body_entered(_body: Node2D) -> void:
	camera.limit_smoothed = true
	set_physics_process(true)
	player_in_area = true
	

func _on_body_exited(_body: Node2D) -> void:
	set_physics_process(false)
	player_in_area = false
	

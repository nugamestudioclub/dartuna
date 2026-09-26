extends Node3D

@onready var body: CharacterBody3D = $CharacterBody3D  # adjust to the real node name

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var launched := false

func launch(launch_velocity: Vector3) -> void:
	body.velocity = launch_velocity
	launched = true

func _physics_process(delta: float) -> void:
	if not launched:
		return
	body.velocity.y -= gravity * delta  # remove this line for a straight-flying dart
	var collision = body.move_and_collide(body.velocity * delta)
	if collision:
		launched = false  # dart sticks where it hits

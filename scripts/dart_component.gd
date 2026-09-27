extends Node3D

@export var power: float = 1.0

@onready var body: CharacterBody3D = $CharacterBody3D  # uses real node name.

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var launched := false

func launch(launch_velocity: Vector3) -> void:
	var _lvelocity = launch_velocity;
	_lvelocity.x *= power;
	body.velocity = _lvelocity
	launched = true



func _physics_process(delta: float) -> void:
	if not launched:
		return
	body.velocity.y -= gravity * delta  # drop effect

	var collision = body.move_and_collide(body.velocity * delta)
	if collision:
		launched = false  # dart sticks where it hits
	
	

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
	
	# Rotate the body in place, and skip cases look_at can't handle
	var dir := body.velocity.normalized()
	if body.velocity.length_squared() > 0.0001 and abs(dir.dot(Vector3.UP)) < 0.999:
		body.look_at(body.global_position + body.velocity, Vector3.UP)
	
	var collision = body.move_and_collide(body.velocity * delta)
	if collision:
		launched = false  # dart sticks where it hits
		if collision.get_collider().has_method("hit"):
			var pos:Vector3 = body.global_position;
			collision.get_collider().hit(pos)
	
	

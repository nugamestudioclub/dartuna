extends CharacterBody3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta;
	move_and_slide()

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


@export var board_radius: float = 1.0  # radius of the outer edge, in the node's local units
# Upper bound of each radius bin, normalized so the outer edge = 1.0
const RADIUS_BINS: Array[float] = [
	0.05,  # 0: red (inner bull)
	0.10,  # 1: green (outer bull)
	0.55,  # 2: first layer
	0.64,  # 3: colored layer 1
	0.95,  # 4: second layer
	1.00,  # 5: final color layer
]
const ANGULAR_BINS: int = 20


func get_tile(location: Vector3) -> Array:
	# Make location relative to center (also accounts for the board's rotation/scale)
	var rel_location: Vector3 = to_local(location)
	var x_delta := rel_location.x
	var y_delta := rel_location.y

	# Distance from center, normalized to 0..1
	var radius := Vector2(x_delta, y_delta).length() / board_radius

	# Which radius bin? (-1 = missed the board)
	var radius_bin := -1
	for i in RADIUS_BINS.size():
		if radius < RADIUS_BINS[i]:
			radius_bin = i
			break

	# Angle from the +X axis, wrapped into [0, TAU)
	var angle := fposmod(atan2(y_delta, x_delta), TAU)

	# Which angular bin? (each is 360/20 = 18 degrees)
	var bin_size := TAU / ANGULAR_BINS
	var angular_bin := int(angle / bin_size) % ANGULAR_BINS

	return [radius_bin, angular_bin]

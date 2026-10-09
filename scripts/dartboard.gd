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
	0.10,  # 0: red (inner bull)
	0.20,  # 1: green (outer bull)
	1.10,  # 2: first layer
	1.28,  # 3: colored layer 1
	1.9,  # 4: second layer
	2.00,  # 5: final color layer
]
const ANGULAR_BINS: int = 20;

func _get_rad_bin_simple(radius:float) -> int:
	for i in range(len(RADIUS_BINS)):
		if radius <= RADIUS_BINS[i]:
			return i;
	return -1;
	

func get_tile(location: Vector3) -> Array:
	# get location
	var obj_location = global_position;
	# get the relative vector dartboard-->dart
	var local_hit = location-obj_location;
	# project into 2D
	var hit_2d := Vector2(local_hit.x, local_hit.y)
	# extract the radius
	var r := hit_2d.length()
	# normalize the hit vector
	hit_2d = hit_2d.normalized();
	# determine theta rel
	var theta := rad_to_deg(hit_2d.angle())
	# determine theta 360 degrees
	var theta_360 := fposmod(theta, 360.0)
	
	# binning action
	var ang_bin:int = floor(theta_360/ANGULAR_BINS);
	var rad_bin:int = _get_rad_bin_simple(r);
	return [rad_bin, ang_bin]


func hit(_location:Vector3) -> void:
	var output = get_tile(_location);
	print("[DARTBOARD] (rad_bin, angular_bin) =",output);
	
	
	return;

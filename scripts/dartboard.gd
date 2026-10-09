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
	
# Gets the triagular space that you are located on on a dartboard relative to radius and angle around the 
# dartboard. This method accounts for the straight edges of the outside of each space.
func _get_rad_bin_complex(radius:float, theta_360:float, theta_bin:int) -> int:
	#1. get binned angle theta_bin*20 which < theta_360.
	var theta_a = 20 * theta_bin;
	var theta_b = 20*(theta_bin+1)
	#2. for each bound, increase the radius to get the positions 
	var a_norm = Vector2(cos(deg_to_rad(theta_a)),sin(deg_to_rad(theta_a)));
	var b_norm = Vector2(cos(deg_to_rad(theta_b)),sin(deg_to_rad(theta_b)));
	var c = Vector2(cos(deg_to_rad(theta_360)), sin(deg_to_rad(theta_360)))*radius;
	for r in ANGULAR_BINS:
		var a = a_norm * r;
		var b = b_norm * r;
		var ab = b-a;
		var ca = c-a;
		var bin_ang = ab.dot(a);
		var pt_ang = ca.dot(a);
		print("RADIUS REL: ",r, " RADIUS: ",radius)
		print("BIN ANGLE: ",bin_ang)
		print("PT ANGLE: ",pt_ang);
		
		
	return 0;

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
	var rad_comp:int = _get_rad_bin_complex(r,theta_360,ang_bin);
	
	return [rad_bin, ang_bin]


func hit(_location:Vector3) -> void:
	var output = get_tile(_location);
	print("[DARTBOARD] (rad_bin, angular_bin) =",output);
	
	
	
	return;

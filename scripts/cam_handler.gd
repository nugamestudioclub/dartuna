extends Node3D
@export var mi:MeshInstance3D
var prev_tim_int:int=6.0
var x_displace:float=0.0
var y_displace:float=0.0
@onready var cam:=$Camera3D
@onready var tim:=$AimTimer

var target_position:Vector3= Vector3.ZERO;

var g: Vector3 = ProjectSettings.get_setting("physics/3d/default_gravity") \
	* ProjectSettings.get_setting("physics/3d/default_gravity_vector")

const DART_PREFAB = preload("res://assets/prefabs/dart_template.tscn")


func calculate_launch_vector(origin: Vector3, destination: Vector3, speed: float, gravity: Vector3, high_arc: bool = false) -> Vector3:
	print("Launching from:",origin);
	print("Launching to:",destination);
	
	var d := destination - origin
	var gg := gravity.dot(gravity)
	# No gravity: just fire straight at it
	if gg < 0.0001:
		return d.normalized() * speed

	var b := d.dot(gravity) + speed * speed
	var discriminant := b * b - gg * d.dot(d)
	
	if discriminant < 0.0:
		print("DISCRIMINANT:",discriminant);
		return Vector3.ZERO  # Out of range at this speed

	var root := sqrt(discriminant)
	var u := (b + root if high_arc else b - root) / (gg * 0.5)  # u = t^2

	if u <= 0.0:
		print("ZERO RETURN")
		return Vector3.ZERO

	var t := sqrt(u)
	var vec:Vector3 = Vector3()
	vec = d / t - gravity * (0.5 * t)
	vec.x *=0.25;
	
	print("RESULT VECTOR:",vec);
	return vec
	
func _spawn_launch() -> void:
	var origin:Vector3 = global_position;
	var v := calculate_launch_vector(origin, target_position, 25, g);
	
	var dart = DART_PREFAB.instantiate();
	get_tree().current_scene.add_child(dart);
	dart.global_position = global_position;
	dart.launch(v);

func _physics_process(delta: float) -> void:
	var mousePos:=get_viewport().get_mouse_position()
	#These lines help to set up the two points in space for the ray
	var rayStart :Vector3=cam.project_ray_origin(mousePos)
	var direction :Vector3=cam.project_ray_normal(mousePos)
	var space_state:=get_world_3d().direct_space_state
	var p:PhysicsRayQueryParameters3D=PhysicsRayQueryParameters3D.create(rayStart,rayStart+direction*1000.0)
	var result:=space_state.intersect_ray(p)#This is the mouse pos
	if result:
		if(Input.is_action_pressed("on_mouse_pressed")):
			#Could do some division with possible lossy conversions or rounding to change it
			#Use some lerp for smoothness
			
			"""Declares both the random x and y displacement away from mouse
			Also triggers every .6 seconds to change to a new position"""
			if((int(tim.get_time_left()/0.6)!=prev_tim_int)and tim.get_time_left()!=0.0):
				prev_tim_int=int(tim.get_time_left()/.6)
				x_displace=randf_range(x_displace-0.1,x_displace+0.1)
				y_displace=randf_range(y_displace-0.1,y_displace+0.1)
				target_position = result.position + Vector3(x_displace,y_displace,0);
				print("Set target pos:",target_position)
			#This if will make sure it picks 5 different spots and make smooth movements to each
			var forward_vec:Vector3 = (cam.position-result.position).normalized();
			
			mi.global_position=lerp(mi.global_position,Vector3(result.position.x+x_displace,result.position.y+y_displace,result.position.z)+forward_vec*5.0,.18)
		else:
			#Makes the thing move with the mouse mi being the mesh instance
			mi.global_position=result.position
		#This resets the values of x and y displacement on release
		if(Input.is_action_just_released("on_mouse_pressed")):
			x_displace=0.0
			y_displace=0.0
			prev_tim_int=6.0

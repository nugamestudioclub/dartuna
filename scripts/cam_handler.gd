extends Node3D
@export var mi:MeshInstance3D
var prev_tim_int:int=6.0
var x_displace:float=0.0
var y_displace:float=0.0
@onready var cam:=$Camera3D
@onready var tim:=$AimTimer
func _physics_process(delta: float) -> void:
	var mousePos:=get_viewport().get_mouse_position()
	#print(mousePos)
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
				x_displace=randf_range(x_displace-2.5,x_displace+2.5)
				y_displace=randf_range(y_displace-2.5,y_displace+2.5)
			#This if will make sure it picks 5 different spots and make smooth movements to each
			mi.global_position=lerp(mi.global_position,Vector3(result.position.x+x_displace,result.position.y+y_displace,result.position.z),.18)
		else:
			#Makes the thing move with the mouse mi being the mesh instance
			mi.global_position=result.position
		#This resets the values of x and y displacement on release
		if(Input.is_action_just_released("on_mouse_pressed")):
			x_displace=0.0
			y_displace=0.0
			prev_tim_int=6.0

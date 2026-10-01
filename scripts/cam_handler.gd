extends Node3D
@export var mi:MeshInstance3D
var prev_tim_int:int
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
	#For whatever reason if you do 0.0 it won't accurately read direction like in the youtube tutorial
	#However it'll return null if you go to either the top or bottom half of the screen
	"""var plane:=Plane(Vector3.UP)
	#Bug with intersection equaling rayStart for some reason
	var intersection=plane.intersects_ray(rayStart,direction)
	print(intersection)"""
	var space_state:=get_world_3d().direct_space_state
	var p:PhysicsRayQueryParameters3D=PhysicsRayQueryParameters3D.create(rayStart,rayStart+direction*1000.0)
	var result:=space_state.intersect_ray(p)#This is the mouse pos
	if result:
		if(Input.is_action_pressed("on_mouse_pressed")):
			#Could do some division with possible lossy conversions or rounding to change it
			#Use some lerp for smoothness
			
			#Declares both the random x and y away from mouse
			if(tim.get_time_left()==3.0 or int(tim.get_time_left()/0.6)!=prev_tim_int):
				prev_tim_int=int(tim.get_time_left()/.6)
				x_displace=randf_range(x_displace-2.5,x_displace+2.5)
				y_displace=randf_range(y_displace-2.5,y_displace+2.5)
			#This if will make sure it picks 5 different spots
			mi.global_position=lerp(mi.global_position,Vector3(result.position.x+x_displace,result.position.y+y_displace,result.position.z),.18)
		else:
			mi.global_position=result.position
		if(Input.is_action_just_released("on_mouse_pressed")):
			x_displace=0.0
			y_displace=0.0

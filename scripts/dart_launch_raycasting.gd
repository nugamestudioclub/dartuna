extends Node3D

@export var targetboard_bounds: Vector3 = Vector3(4,4,4);
@onready var raycast: RayCast3D = $RayCast3D_Camera


var g: Vector3 = ProjectSettings.get_setting("physics/3d/default_gravity") \
	* ProjectSettings.get_setting("physics/3d/default_gravity_vector")

const DART_PREFAB = preload("res://assets/prefabs/dart_template.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func calculate_launch_vector(origin: Vector3, destination: Vector3, speed: float, gravity: Vector3, high_arc: bool = false) -> Vector3:
	var d := destination - origin
	var gg := gravity.dot(gravity)

	# No gravity: just fire straight at it
	if gg < 0.0001:
		return d.normalized() * speed

	var b := d.dot(gravity) + speed * speed
	var discriminant := b * b - gg * d.dot(d)

	if discriminant < 0.0:
		return Vector3.ZERO  # Out of range at this speed

	var root := sqrt(discriminant)
	var u := (b + root if high_arc else b - root) / (gg * 0.5)  # u = t^2

	if u <= 0.0:
		return Vector3.ZERO

	var t := sqrt(u)
	var vec:Vector3 = Vector3()
	vec = d / t - gravity * (0.5 * t)
	vec.x *=0.25;
	return vec
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		var mouse_pos: Vector2 = get_viewport().get_mouse_position() / get_viewport().get_visible_rect().size
		var converted_mouse_pos:Vector3;
		converted_mouse_pos.z = 2*(0.5-mouse_pos.x);
		converted_mouse_pos.y = 2*(mouse_pos.y-0.5);
		converted_mouse_pos = -converted_mouse_pos*targetboard_bounds;

		var cam := get_viewport().get_camera_3d()
		var from := cam.project_ray_origin(event.position)
		var to := from + cam.project_ray_normal(event.position) * 100.0

		var query := PhysicsRayQueryParameters3D.create(from, to)
		var result := get_world_3d().direct_space_state.intersect_ray(query)
		if result:
			var v := calculate_launch_vector(global_position, result.position, 10, g)
			print(v);
			var dart = DART_PREFAB.instantiate();
			get_tree().current_scene.add_child(dart);
			dart.global_position = global_position;
			dart.launch(v);
			
	pass

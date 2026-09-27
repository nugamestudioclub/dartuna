extends Node3D

const BULLET_PREFAB = preload("res://assets/prefabs/dart_template.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		var mouse_pos: Vector2 = get_viewport().get_mouse_position() / get_viewport().get_visible_rect().size
		var off = Vector3(2,0.5-mouse_pos.y, mouse_pos.x-0.5)
		var direction = Vector2(off.z,off.y)*2
		
		fire_bullet(off,direction);

func fire_bullet(init_pos: Vector3,direction:Vector2) -> void:
	var bullet = BULLET_PREFAB.instantiate();
	get_tree().current_scene.add_child(bullet);
	bullet.global_position = global_position+init_pos; 
	bullet.launch(Vector3(10,direction.y*2,direction.x*2));

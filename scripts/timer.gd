extends Timer


# Called when the node enters the scene tree for the first time.
var tim_on:=false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if(Input.is_action_pressed("on_mouse_pressed")):
		if(tim_on==false):
			tim_on=true
			start()
		print(get_time_left())
	if(Input.is_action_just_released("on_mouse_pressed")):
		print('rel')
		stop()
		tim_on=false
		set_wait_time(3.0)
func _on_timeout() -> void:
	print('Fire Dart')

extends Timer
"""Currently this script times how long the mouse is clicked for and at 3 seconds prints fire dart
on release of the mouse prints rel and prints the time while the mouse is held"""
# Called when the node enters the scene tree for the first time.
var tim_on:=false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	"""On mouse pressed it will start the timer"""
	if(Input.is_action_pressed("on_mouse_pressed")):
		#This is to prevent it from hitting the start button a bunch of times while holding down click
		if(tim_on==false):
			tim_on=true
			start()
		print(get_time_left())
	#Stops the timer when you release the click
	if(Input.is_action_just_released("on_mouse_pressed")):
		print('rel')
		stop()
		tim_on=false
#Fires the dart after the three second timer
func _on_timeout() -> void:
	print('Fire Dart')

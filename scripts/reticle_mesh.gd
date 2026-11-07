extends MeshInstance3D
@onready var animReticle:=$Animated_Reticle
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if(Input.is_action_pressed("on_mouse_pressed")):
		#If the animation is not already playing plays it
		if(animReticle.is_playing()==false):
			animReticle.play()
	#resets to frame 0 on release
	else:
		animReticle.set_frame_and_progress(0,0.0)
	#Uses the invisible mesh instances position and sets it equal to its own
	animReticle.position=position

extends Node3D
@onready var segmented_dartboard: Node3D = $SegmentedDartboard
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var mesh_scale = 0.001
var scaled = false

var dart_board_scale = 0.001
var d_scaled = false
func _ready() -> void:
	segmented_dartboard.scale = Vector3(dart_board_scale, dart_board_scale, dart_board_scale)
	mesh_instance_3d.scale = Vector3(mesh_scale, mesh_scale, mesh_scale * 17.0)
	audio_stream_player.play(0.1)

func _process(delta: float) -> void:
	if not scaled:
		mesh_scale += mesh_scale * 0.05
		mesh_instance_3d.scale = Vector3(mesh_scale, mesh_scale, mesh_scale * 17.0)
		if mesh_scale >= 3:
			mesh_scale = 3
			mesh_instance_3d.scale = Vector3(mesh_scale, mesh_scale, mesh_scale * 17.0)
			scaled = true
	else:
		if not d_scaled:
			dart_board_scale += dart_board_scale * 0.05
			segmented_dartboard.scale = Vector3(dart_board_scale, dart_board_scale, dart_board_scale)
			if dart_board_scale >= 1.3:
				dart_board_scale = 1.3
				segmented_dartboard.scale = Vector3(dart_board_scale, dart_board_scale, dart_board_scale)
				d_scaled = true
	segmented_dartboard.rotate_x(0.005)

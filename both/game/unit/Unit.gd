class_name Unit

extends CharacterBody3D
signal new_position
enum commands{z,x,c,v}
var material: StandardMaterial3D
var mesh_instance: MeshInstance3D
var player_id: int

var target_position: Vector3: 
	set(value):
		target_position = value
		new_position.emit()

@rpc("any_peer")
func command(type) -> void:
	pass

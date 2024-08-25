class_name Unit

extends CharacterBody3D
signal new_position
var material: StandardMaterial3D
var mesh_instance: MeshInstance3D

var player_id: int:
	set(value):
		print("id: " + str(value))
		player_id = value


var target_position: Vector3: 
	set(value):
		new_position.emit()
		target_position = value

@rpc("any_peer")
func select(player: String) -> void:
	if player_id == multiplayer.get_remote_sender_id():
		var plobj := get_node(player)
		if plobj is Player:
			plobj.units.append(self)

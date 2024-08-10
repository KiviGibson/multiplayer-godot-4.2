class_name Server

extends Node

const PORT := 2555
const MAX_TRAFFIC := 10
func _ready() -> void:
	print("Starting Server")
	var peer := ENetMultiplayerPeer.new()
	var err := peer.create_server(PORT, MAX_TRAFFIC)
	if err:
		print("Error occured: "+ error_string(err))
		return
	multiplayer.multiplayer_peer = peer
	print("Server listening on port: " + str(PORT))
	multiplayer.peer_connected.connect(_on_player_connection)
	multiplayer.peer_disconnected.connect(_on_player_disconnection)
	
func _on_player_connection(id: int) -> void:
	print("Player connected, ID:" + str(id))

func _on_player_disconnection(id: int) -> void:
	print("Player disconnected, ID:" + str(id))

class_name Client

extends Node

const ADDRESS := "192.168.1.100"
const PORT := 2555
func _ready() -> void:
	print("Starting Client")
	var peer := ENetMultiplayerPeer.new()
	var err := peer.create_client(ADDRESS, PORT)
	if err:
		print(err)
		return
	multiplayer.multiplayer_peer = peer
	multiplayer.connected_to_server.connect(_on_connection)
	multiplayer.connection_failed.connect(_on_connection_fail)
	multiplayer.server_disconnected.connect(_on_connection)

func _on_connection() -> void:
	print("Connected to server")
func _on_connection_fail() -> void:
	print("Connection failed")
func _on_disconnection() -> void:
	print("Disconected from server")

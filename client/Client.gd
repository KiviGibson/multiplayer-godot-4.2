class_name Client

extends Node3D

const ADDRESS := "127.0.0.1"
const PORT := 2555
func _ready() -> void:
	self.name = "multi"
	multiplayer.connected_to_server.connect(_on_connection)
	multiplayer.connection_failed.connect(_on_connection_fail)
	multiplayer.server_disconnected.connect(_on_connection)
	create_peer()

func create_peer() -> void:
	print("Starting Client")
	var peer := ENetMultiplayerPeer.new()
	var err := peer.create_client(ADDRESS, PORT)
	if err:
		print(err)
		return
	multiplayer.multiplayer_peer = peer
	
func _on_connection() -> void:
	print("Connected to server")
	
func _on_connection_fail() -> void:
	print("Connection failed")
	create_peer()

func _on_disconnection() -> void:
	print("Disconected from server")

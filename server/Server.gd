class_name Server

extends Node3D

const PORT := 2555
const MAX_TRAFFIC := 10
var current_lobby: Lobby
var lobby_id := 0
func _ready() -> void:
	self.name = "multi"
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
	if not multiplayer.is_server():
		return
	if current_lobby == null or current_lobby.full:
		current_lobby = lobby_manager.add_lobby("Lobby"+str(lobby_id), self)
		lobby_manager.enter_lobby.rpc_id(id, "Lobby" + str(lobby_id))
		print("lobby created")
	else:
		lobby_manager.enter_lobby.rpc_id(id, "Lobby" + str(lobby_id))
		print("lobby joined")
		lobby_id += 1
	print("Player connected, ID:" + str(id))

func _on_player_disconnection(id: int) -> void:
	print("Player disconnected, ID:" + str(id))

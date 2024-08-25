class_name LobbyManager

extends Node

var lobby: PackedScene = preload("res://both/lobby/lobby.tscn")

@rpc("authority")
func enter_lobby(n: String) -> void:
	# making player join the lobby
	var root := get_node("/root/multi")
	var scheme := Node3D.new()
	scheme.name = n
	root.add_child(scheme,true)
	scheme.add_child(lobby.instantiate())

func add_lobby(n: String, parent: Node3D) -> Lobby:
	# adding new lobby
	if multiplayer.is_server():
		var new_window := Window.new()
		new_window.set_world_3d(World3D.new())
		new_window.name = n
		parent.add_child(new_window,true)
		var l := lobby.instantiate()
		new_window.add_child(l)
		return l
	return

@rpc("any_peer")
func join_lobby(n: String) -> void:
	if not multiplayer.is_server():
		return
	var req_id := multiplayer.get_remote_sender_id()
	# double names becouse of structure Viewport/Lobby Node with the same name
	var lobby_node := get_node("/root/multi/"+n+"/Lobby")
	if not (lobby_node is Lobby):
		return
	if lobby_node.full:
		return
	enter_lobby.rpc_id(req_id, n)
	pass

@rpc("any_peer")
func create_lobby(_n:String) -> void:
	var _req_id := multiplayer.get_remote_sender_id()
	# if name isn't in pool player creates a lobby and then joins it
	pass

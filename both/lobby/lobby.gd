class_name Lobby

extends Node3D

var players: Node3D
var player_scene: PackedScene = preload("res://both/player.tscn")
var max_players: int = 2
var curr_players: int = 0
var full: bool = false
var ids: Array[int] = []
@export var game_root: Game
@export var spawner: MultiplayerSpawner

@rpc("any_peer")
func add_player() -> void:
	if not multiplayer.is_server():
		return
	var id := multiplayer.get_remote_sender_id()
	if not id in ids:
		ids.append(id)
	curr_players += 1
	if curr_players == max_players:
		full = true
		spawn_players()

func spawn_players() -> void:
	if not multiplayer.is_server():
		return
	game_root.initialize_map()
	for id in ids:
		var player: Node3D = player_scene.instantiate()
		if player is Player:
			player.name = str(id)
			player.game = game_root
			self.add_child(player, true)
			var start_position = game_root.spawn_base_equipment(id)
			player.global_position = start_position
		else:
			print("Error: Player isn't instatate corecctly!")

func _ready() -> void:
	if multiplayer.is_server():
		return
	add_player.rpc()

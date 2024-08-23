class_name Lobby

extends Node3D

var players: Node3D
var player_scene: PackedScene = preload("res://both/player.tscn")
var max_players: int = 2
var curr_players: int = 0
var full: bool = false
var ids: Array[int] = []
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
	for id in ids:
		var player: CharacterBody3D = player_scene.instantiate()
		player.name = str(id)
		self.add_child(player, true)
		player.global_position = Vector3.ZERO

func _ready() -> void:
	if multiplayer.is_server():
		return
	add_player.rpc()
		

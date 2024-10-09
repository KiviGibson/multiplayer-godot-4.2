class_name Game

extends Node3D
@export var worker_scene: PackedScene
@export var base: PackedScene
@export var start_worker_amount: int
var map_node: MapNode

func initialize_map() -> void:
	if not multiplayer.is_server():
		return
	var m := len(global.maps)-1
	var choosen_map := global.maps[randi_range(0,m)]
	var map_root: Node3D = load(choosen_map.scene_path).instantiate()
	self.add_child(map_root,true)
	map_node = map_root

func spawn_base_equipment(player_id: int) -> Vector3:
	if not multiplayer.is_server():
		return Vector3.ZERO
	var spawn: Node3D = map_node.spawns.pop_front()
	for i in range(start_worker_amount):
		var worker: Worker = worker_scene.instantiate()
		worker.name = "Worker" + str(randi())
		worker.player_id = player_id
		add_child(worker, true)
		worker.global_position = spawn.global_position + Vector3(randf_range(-1,1),0 ,randf_range(-1,1))
	var base_node:Structure = base.instantiate()
	var base_pos: Vector3 = map_node.bases.pop_front().global_position
	base_node.name = "MainBase" + str(randi())
	base_node.player_id = player_id
	base_node.bilt.connect(_on_structure_bilt)
	map_node.add_child(base_node, true)
	base_node.global_position = base_pos
	base_node.game_root = self
	return base_pos

func _on_structure_bilt() -> void:
	if not multiplayer.is_server():
		return
	print("Trying to bake")
	map_node.bake_map.call_deferred()

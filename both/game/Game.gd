class_name Game

extends Node3D
@export var worker_scene: PackedScene

func spawn_worker(player_id: int) -> void:
	var worker: Worker = worker_scene.instantiate()
	worker.name = "worker" + str(randi())
	worker.player_id = player_id
	add_child(worker)
	worker.global_position += Vector3(randf_range(-3,3),0 ,randf_range(-3,3))


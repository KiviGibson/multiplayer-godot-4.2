extends MultiplayerSpawner

@export var path_to_map: StringName = "res://both/game/maps/"

func _ready() -> void:
	var dir := DirAccess.open(path_to_map)
	for map_name in dir.get_files():
		self.add_spawnable_scene(path_to_map+map_name)

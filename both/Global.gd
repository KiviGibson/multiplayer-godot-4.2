class_name Global

extends Node

var maps: Array[map]
var map_base_path := "res://both/game/maps/"
func _ready() -> void:
	var directory := DirAccess.open(map_base_path)
	for file in directory.get_files():
		var cmap :map = map.new()
		cmap.map_name = file.get_slice(".",0).replace("_", " ")
		cmap.scene_path = map_base_path + file
		print([cmap.map_name, cmap.scene_path])
		maps.append(cmap)

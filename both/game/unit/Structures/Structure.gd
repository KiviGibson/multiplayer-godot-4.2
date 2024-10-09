class_name Structure

extends Unit

signal bilt
signal destroyed

var game_root: Game
class TrainableUnit:
	var time: float
	var item: PackedScene

func _ready() -> void:
	if not multiplayer.is_server():
		return
	bilt.emit()
	print("Built: " + self.name)

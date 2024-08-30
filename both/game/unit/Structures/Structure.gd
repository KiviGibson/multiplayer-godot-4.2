class_name Structure

extends Unit

signal bilt
signal destroyed

func _ready() -> void:
	if not multiplayer.is_server():
		return
	bilt.emit()
	print("Built: " + self.name)

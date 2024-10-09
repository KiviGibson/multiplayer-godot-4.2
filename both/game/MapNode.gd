class_name MapNode

extends NavigationRegion3D

@export var bases: Array[Node3D]
@export var spawns : Array[Node3D]
var is_baking := false
var is_requested_baking := false
func _ready() -> void:
	self.bake_finished.connect(_on_baking_finished)
	
func bake_map() -> void:
	if not multiplayer.is_server():
		return
	if is_baking:
		is_requested_baking = true
	else:
		is_baking = true
		self.bake_navigation_mesh()

func _on_baking_finished() -> void:
	if is_requested_baking:
		bake_navigation_mesh()
		is_requested_baking = false
	else:
		is_baking = false
	print("baking good!")

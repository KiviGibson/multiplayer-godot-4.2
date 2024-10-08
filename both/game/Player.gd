class_name Player

extends Node3D

var game: Game
@export var cam: Camera3D
@export var cam_controll: Node3D
@export var selection: Area3D
@export var decal: Node3D
var units: Array[Unit]
var selection_start: Vector2 = Vector2(0,0)
var offset := 20
var speed := 10
var editing := false
func _ready() -> void:
	if self.name == str(multiplayer.get_unique_id()):
		cam.visible = true


func _process(delta: float) -> void:
	if multiplayer.is_server() and cam == null:
		return
	move_camera(delta)
	if Input.is_action_just_pressed("Select"):
		on_mouse_press()
		editing = true
		decal.visible = true
	if Input.is_action_just_released("Select"):
		on_mouse_release()
		editing = false
		decal.visible = false
	if Input.is_action_just_pressed("Move"):
		move_units.rpc(cam.project_position(get_viewport().get_mouse_position(), 10))
	if editing:
		editing_selection()
# Player Input
func move_camera(delta: float) -> void:
	var view := get_viewport()
	var mouse_position := view.get_mouse_position()
	var screen_size:Vector2 = view.size
	if 0 <= mouse_position.x and mouse_position.x <= offset:
		cam_controll.global_position.x -= speed * delta
		cam_controll.global_position.z += speed * delta
	elif screen_size.x >= mouse_position.x and mouse_position.x >= screen_size.x - offset:
		cam_controll.global_position.x += speed * delta
		cam_controll.global_position.z -= speed * delta
	if 0 <= mouse_position.y and mouse_position.y <= offset:
		cam_controll.global_position.x -= speed * delta
		cam_controll.global_position.z -= speed * delta
		pass
	elif screen_size.y >= mouse_position.y and mouse_position.y >= screen_size.y - offset:
		cam_controll.global_position.z += speed * delta
		cam_controll.global_position.x += speed * delta

func on_mouse_press() -> void:
	var mouse_position := cam.project_position(get_viewport().get_mouse_position(), 10)
	selection_start =  Vector2(mouse_position.x, mouse_position.z)
	print(selection_start)

func editing_selection() -> void:
	var mouse_position = cam.project_position(get_viewport().get_mouse_position(), 10)
	var pos := Vector2(mouse_position.x, mouse_position.z)
	var vector := get_vectors(selection_start, pos)
	var difference := Vector2(abs(vector.z-vector.x), abs(vector.y-vector.w)) 
	decal.global_position = Vector3(vector.z,0,vector.w)
	decal.scale = Vector3(difference.x,difference.x*difference.y,difference.y)
	selection.global_position = Vector3(vector.z,0,vector.w)
	selection.scale = Vector3(difference.x,1,difference.y)

func on_mouse_release() -> void:
	deselect.rpc()
	for obj in selection.get_overlapping_bodies():
		if obj is Unit:
			print(obj.name)
			select.rpc(obj.get_path())

# Select Units
@rpc("any_peer")
func select(selected_unit: String) -> void:
	var node: Unit = get_node(selected_unit)
	if node.player_id == multiplayer.get_remote_sender_id():
		self.units.append(node)
		print("Added: " + self.name+ " to be controlled by: " + str(node.player_id))

@rpc("any_peer")
func deselect() -> void:
	units.clear()

# Unit Commands
@rpc("any_peer")
func move_units(point: Vector3) -> void:
	if not multiplayer.is_server():
		return
	for unit in units:
		if unit.player_id == multiplayer.get_remote_sender_id():
			unit.target_position = point

func get_vectors(a: Vector2, b:Vector2) -> Vector4:
	return Vector4(min(a.x, b.x), min(a.y, b.y), max(a.x, b.x), max(a.y, b.y))

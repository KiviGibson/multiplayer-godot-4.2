class_name MovingUnit

extends Unit

const SPEED = 5.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
@export var pathfinding: NavigationAgent3D
func _ready() -> void:
	self.new_position.connect(_new_position)
func _new_position() -> void:
	pathfinding.target_position = target_position
func _physics_process(_delta: float) -> void:
	if not multiplayer.is_server():
		return
	var direction: Vector3
	if not pathfinding.is_navigation_finished():
		direction = (pathfinding.get_next_path_position()-self.global_position).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()

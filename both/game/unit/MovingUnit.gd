class_name MovingUnit

extends Unit

@export var speed = 5.0

@export var pathfinding: NavigationAgent3D
var gravity: float = 9.8
func _ready() -> void:
	self.new_position.connect(_new_position)

func _new_position() -> void:
	pathfinding.target_position = target_position

func _physics_process(_delta: float) -> void:
	if not multiplayer.is_server():
		return
	var direction: Vector3
	if not is_on_floor():
		velocity.y -= gravity
	else:
		velocity.y = 0
	if not pathfinding.is_navigation_finished():
		direction = (pathfinding.get_next_path_position()-self.global_position).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	move_and_slide()

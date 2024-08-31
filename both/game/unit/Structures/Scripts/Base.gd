class_name Base

extends Structure

var training_queue: Array[TrainableUnit] = [null, null, null, null, null]
var first_index := 0
var last_index := 0
var capacity := 5

@export var worker: PackedScene
@export var timer: Timer

func _ready() -> void:
	super._ready()
	print(training_queue)
	target_position = global_position+ Vector3(1,0,1)

func command(type: String) -> void:
	if type == "z":
		var new_unit = TrainableUnit.new()
		new_unit.item = worker
		new_unit.time = 5
		training_queue[last_index] = new_unit
		print(training_queue)
		if first_index == last_index:
			spawn_unit()
		last_index += 1
		last_index %= capacity

func spawn_unit() -> void:
	timer.wait_time = training_queue[first_index].time
	timer.start()

func _on_unit_train_taimer_timeout() -> void:
	var unit: Unit = training_queue[first_index].item.instantiate()
	first_index += 1
	first_index %= capacity
	unit.name = "Worker" + str(randi())
	unit.player_id = player_id
	game_root.add_child(unit, true)
	unit.global_position = self.global_position + target_position.normalized() * 2
	unit.target_position = target_position
	print("Spawn: " + str(unit.global_position))
	print(str(first_index) + " " + str(last_index))
	if first_index != last_index:
		spawn_unit()

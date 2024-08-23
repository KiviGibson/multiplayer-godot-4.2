class_name GameInitializer

extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var argv := OS.get_cmdline_args()
	if argv.has("-s"):
		print(argv)
		_on_server_pressed.call_deferred()
		remove_me()

func _on_client_pressed() -> void:
	self.get_tree().root.add_child(Client.new())
	remove_me()

func _on_server_pressed() -> void:
	self.get_tree().root.add_child(Server.new())
	remove_me()

func remove_me() -> void:
	self.get_parent().queue_free()

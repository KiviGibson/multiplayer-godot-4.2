class_name GameInitializer

extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var argv := OS.get_cmdline_args()
	if argv.has("-s"):
		print(argv)
		var parent = get_parent()
		_on_server_pressed.call_deferred()
		remove_me()

func _on_client_pressed() -> void:
	self.get_parent().add_child(Client.new())
	remove_me()

func _on_server_pressed() -> void:
	self.get_parent().add_child(Server.new())
	remove_me()

func remove_me() -> void:
	self.get_parent().remove_child(self)
	self.queue_free()

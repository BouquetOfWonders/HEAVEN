extends Window


func _ready() -> void:
	Global.ErrorLog.connect(on_error_signal)

func _on_close_requested() -> void:
	get_tree().quit()

func on_error_signal(error: String):
	$Control/ErrorDescription.text = error
	$".".visible = true

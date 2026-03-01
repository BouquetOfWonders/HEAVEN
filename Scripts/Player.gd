extends Node

var CanProcess := false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PathHandler.PathGenerated.connect(READYUP)


func READYUP():
	CanProcess = true

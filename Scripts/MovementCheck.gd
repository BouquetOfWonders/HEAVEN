extends Node

var FramesSinceLastInput :int = 0
var FramesSinceLastTick :int = 0
var AvarageFrames :float = (120/Global.SongBPM) * 60
var CanAction := true
var CanActionCooldownMax :int = floor((120/Global.SongBPM) * 4)
var CanActionCooldown = 0


func _ready() -> void:
	print(AvarageFrames)
	print(CanActionCooldownMax)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if CanAction:
		CanActionCooldown = 0
		
	FramesSinceLastInput += 1
	FramesSinceLastTick += 1
	
	if CanActionCooldown > CanActionCooldownMax:
		CanAction = true
	else:
		CanActionCooldown += 1
		
	if FramesSinceLastInput > round(AvarageFrames):
		FramesSinceLastInput = 0



func _on_audio_stream_player_beat() -> void:
	AvarageFrames = ((5 * AvarageFrames) + FramesSinceLastTick) / 6
	FramesSinceLastTick = 0

func _input(event):
	if not event.is_echo() and event.is_pressed() and CanAction:
		var LateTiming = FramesSinceLastInput
		var EarlyTiming = round(AvarageFrames) - FramesSinceLastInput

		if LateTiming <= 12 or EarlyTiming <= 12:
			print("Success")
		elif LateTiming < EarlyTiming:
			print(floor((120.0 / LateTiming) * 60) - 165)
			print("Late")
		else:
			print(floor((120.0 / EarlyTiming) * 60) - 165)
			print("Early")
		CanAction = false

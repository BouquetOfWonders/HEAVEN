extends AudioStreamPlayer 

var bpm:float = Global.SongBPM

# Tracking the beat and song position
var song_position:float = 0.0
var song_position_in_beats = 0
var seconds_per_beat = 60.0 / bpm
var last_reported_beat = 0
var OutputLatency
signal Beat

func _ready() -> void:
	seconds_per_beat = 60.0 / bpm
	OutputLatency = AudioServer.get_output_latency()


func _process(_delta):
	if playing:
		song_position = get_playback_position()
		song_position -= OutputLatency
		song_position_in_beats = int(floor(song_position / seconds_per_beat))
	_report_beat()
	last_reported_beat = song_position_in_beats

func _report_beat() -> void:
	if last_reported_beat < song_position_in_beats:
		Beat.emit()
		last_reported_beat = song_position_in_beats
		print("tick")

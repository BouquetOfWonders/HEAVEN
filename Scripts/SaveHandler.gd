extends Node


const saveLocation = "user://save.save"
const settingsLocation = "user://settings.save"

static var DefaultSave: Dictionary = {
	"Hihihiha": "Hahahahi"
}

static var DefaultSettings: Dictionary = {
	"language": "en",
	"Master": linear_to_db(1),
	"Music": linear_to_db(1),
	"SoundEffects": linear_to_db(1),
}

var SaveData: Dictionary
var Settings: Dictionary

func _reset():
	var file = FileAccess.open(saveLocation, FileAccess.WRITE)
	file.store_var(DefaultSave.duplicate())
	file.close()
	file = FileAccess.open(settingsLocation, FileAccess.WRITE)
	file.store_var(DefaultSettings.duplicate())

func _save():
	var file = FileAccess.open(saveLocation, FileAccess.WRITE)
	file.store_var(SaveData.duplicate())
	file.close()
	file = FileAccess.open(settingsLocation, FileAccess.WRITE)
	file.store_var(Settings.duplicate())
	file.close()

func _load():
	if not FileAccess.file_exists(saveLocation) or not FileAccess.file_exists(settingsLocation):
		_reset()
	var file = FileAccess.open(saveLocation, FileAccess.READ)
	var data = file.get_var()
	file.close()
	SaveData = data.duplicate()
	
	file = FileAccess.open(settingsLocation, FileAccess.READ)
	data = file.get_var()
	file.close()
	Settings = data.duplicate()
	
	print(SaveData)
	print(Settings)
		
func _fullLoad():
	_load()
	TranslationServer.set_locale(Settings.language)
	
	# Uncomment what's below when Audio buses are added
	
	#var busindex = AudioServer.get_bus_index("Master")
	#AudioServer.set_bus_volume_db(
		#busindex,
		#Settings.Master
	#)
	#busindex = AudioServer.get_bus_index("Music")
	#AudioServer.set_bus_volume_db(
		#busindex,
		#Settings.Music
	#)
	#busindex = AudioServer.get_bus_index("SoundEffects")
	#AudioServer.set_bus_volume_db(
		#busindex,
		#Settings.SoundEffects
	#)

func _ready() -> void:
	_fullLoad()

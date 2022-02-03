extends Node

var SFX_volume = 100
var music_volume = 50

var scene_to_start = 0

func set_music_volume():
	var vol = music_volume/100.0
	var music_bus_index = AudioServer.get_bus_index("Music")
	var volume = linear2db(vol)
	AudioServer.set_bus_volume_db(music_bus_index, volume)

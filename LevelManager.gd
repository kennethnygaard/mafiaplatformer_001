extends Node

export(Array, PackedScene) var levelScenes

var currentLevelIndex = 0

func _ready():
	get_tree().paused = false
	change_level(4)
	pass
	
func change_level(levelIndex):
	currentLevelIndex = levelIndex
	
	if(levelIndex < levelScenes.size()):
		get_tree().change_scene(levelScenes[currentLevelIndex].resource_path)

func increment_level():
	change_level(currentLevelIndex + 1)

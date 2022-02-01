extends Node


func _ready():
	print("Scene to start: " + str($"/root/Globals".scene_to_start))
	$"/root/LevelManager".change_level($"/root/Globals".scene_to_start)

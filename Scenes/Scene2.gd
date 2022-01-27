extends Node

func _ready():
	$Camera2D.global_position = $Gangster_v2.global_position
	get_tree().paused = true

func _process(delta):
	$Camera2D.global_position = $Gangster_v2.global_position 

func unpause():
	get_tree().paused = false

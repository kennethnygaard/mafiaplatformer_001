extends Node

func _ready():
	get_tree().paused = true
	$Camera2D.global_position = $Gangster_v2.global_position

func _process(delta):
	$Camera2D.global_position = $Gangster_v2.global_position
	#$Particles2D.global_position = $Gangster_v2.global_position - Vector2(0, 500)

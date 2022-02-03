extends Node

var start_ammo = [0, 1, 0, 0, 0]
var start_guns = [true, false, false, false, false]
var active_gun = 0

func _ready():
	get_tree().paused = true
	$Camera2D.global_position = $Gangster_v2.global_position

func _process(delta):
	$Camera2D.global_position = $Gangster_v2.global_position
	#$Particles2D.global_position = $Gangster_v2.global_position - Vector2(0, 500)
